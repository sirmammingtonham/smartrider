import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as gtfs from "gtfs";
import * as gtfs_timetable from "gtfs-to-html";
import * as models from "./bus_types";
import * as Promise from "./async_util";
import * as firestore from "typesaurus";
import * as serviceAccount from "./smartrider-4e9e8-service.json";
import { genShapeGeoJSON } from "./bus_util";
import { zipObject, zip, isNumber } from "lodash";
import * as fs from "fs";
import * as os from "os";

const ACTIVE_ROUTES = ["87", "286", "289", "288"];

const config = {
  agencies: [
    {
      agency_key: "cdta",
      url: "https://www.cdta.org/schedules/google_transit.zip",
      exclude: [],
    },
  ],
  sqlitePath: os.tmpdir() + "/gtfs.db",
  csvOptions: {
    skip_lines_with_error: true,
  },
  coordinatePrecision: 5,
  showMap: false,
};

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 540,
  memory: "1GB",
};

console.log("initialized");

const parseAgency = async (db: any) => {
  console.log("started parsing Agency");
  console.time("parseAgency");
  const agency = firestore.collection<models.Agency>("agency");
  const query_res = await db.all(`SELECT * FROM agency`);
  return Promise.map(query_res, (query: any) => {
    return firestore.set(agency, query.agency_id, {
      ...query,
    });
  }).then(() => console.timeEnd("parseAgency"));
};

const parseCalendar = async (db: any) => {
  console.log("started parsing Calendar");
  console.time("parseCalendar");
  const calendar = firestore.collection<models.Calendar>("calendar");
  const query_res = await db.all(`
  SELECT c.*, 
    Group_concat(cd.date)           AS exception_dates, 
    Group_concat(cd.exception_type) AS exception_types 
  FROM   calendar c 
    INNER JOIN calendar_dates cd 
      ON c.service_id = cd.service_id 
  GROUP  BY c.service_id; 
  `);

  return Promise.map(query_res, (query: any) => {
    return firestore.set(calendar, query.service_id, {
      service_id: query.service_id,
      active_days: {
        monday: !!query.monday,
        tuesday: !!query.tuesday,
        wednesday: !!query.wednesday,
        thursday: !!query.thursday,
        friday: !!query.friday,
        saturday: !!query.saturday,
        sunday: !!query.sunday,
      },
      start_date: query.start_date,
      end_date: query.end_date,

      exceptions: zipObject(
        query.exception_dates.split(",").map((x: string) => +x),
        query.exception_types.split(",").map((x: string) => +x)
      ),
    });
  }).then(() => console.timeEnd("parseCalendar"));
};

const parseRoutes = async (db: any) => {
  console.log("started parsing Routes");
  console.time("parseRoutes");
  const routes = firestore.collection<models.Route>("routes");
  const query_res = await db.all(`
  SELECT r.*, 
  Group_concat(c.start_date) AS start_dates,
  Group_concat(c.end_date)   AS end_dates,
  Group_concat(t.trip_id)    AS trip_ids,
  Group_concat(t.shape_id)   AS shape_ids,
  Group_concat(st.stop_sequence) AS stop_sequences,
  Group_concat(s.stop_id)    AS stop_ids,
  Group_concat(t.direction_id) AS direction_ids
  FROM  routes r 
    INNER JOIN trips t 
            ON r.route_id = t.route_id
    INNER JOIN stop_times st 
            ON t.trip_id = st.trip_id 
    INNER JOIN stops s 
            ON st.stop_id = s.stop_id 
    INNER JOIN calendar c
            ON c.service_id = t.service_id
  GROUP  BY r.route_id; 
  `);

  const stops = await await db.all(`SELECT * FROM stops;`);

  function multiDimensionalUnique(arr: any[]) {
    const uniques = [];
    const itemsFound: models.Map<boolean> = {};
    for (let i = 0, l = arr.length; i < l; i++) {
      const stringified = JSON.stringify(arr[i]);
      if (itemsFound[stringified]) {
        continue;
      }
      uniques.push(arr[i]);
      itemsFound[stringified] = true;
    }
    return uniques;
  }

  return Promise.map(query_res, (query: any) => {
    /// the first part removes duplicates and zips the stop_ids and stop_sequences
    /// so we can iterate over both simultaneously (like python zip)...
    /// second part combines values if the stop exists for both forward and back sequences
    const stop_info = multiDimensionalUnique(
      zip(
        query.stop_ids.split(","),
        query.stop_sequences.split(","),
        query.direction_ids.split(",")
      )
    ).reduce((map, currentValue) => {
      if (currentValue[0] in map) {
        if (currentValue[2] === "0") {
          map[currentValue[0]].forward = currentValue[1];
        } else {
          map[currentValue[0]].backward = currentValue[1];
        }
      } else {
        if (currentValue[2] === "0") {
          map[currentValue[0]] = { forward: currentValue[1], backward: -1 };
        } else {
          map[currentValue[0]] = { forward: -1, backward: currentValue[1] };
        }
      }
      return map;
    }, {});

    return firestore.set(routes, query.route_id, {
      ...query,
      route_type: +query.route_type,
      start_date: Math.min(
        ...query.start_dates.split(",").map((x: string) => +x)
      ),
      end_date: Math.max(...query.end_dates.split(",").map((x: string) => +x)),

      // trip_ids: [...new Set<string>(query.trip_ids.split(","))],
      // shape_ids: [...new Set<string>(query.shape_ids.split(","))],

      stops: Object.keys(stop_info).map((stop_id: string) => {
        const curStop = stops.find(
          (element: any) => element.stop_id === stop_id
        );
        return {
          ...curStop,
          stop_sequence_0: +stop_info[stop_id].forward,
          stop_sequence_1: +stop_info[stop_id].backward,
        };
      }),
    });
  }).then(() => console.timeEnd("parseRoutes"));
};

const parseShapes = async (db: any) => {
  console.log("started parsing Shapes");
  console.time("parseShapes");
  const shapes = firestore.collection<models.Shape>("shapes");
  const query_res = await db.all(`
  SELECT s.shape_id, 
      Group_concat(s.shape_pt_lat)        AS shape_pt_lat, 
      Group_concat(s.shape_pt_lon)        AS shape_pt_lon, 
      Group_concat(s.shape_pt_sequence)   AS shape_pt_sequence, 
      Group_concat(s.shape_dist_traveled) AS shape_dist_traveled 
  FROM   shapes s 
  GROUP  BY s.shape_id 
  `);
  return Promise.map(query_res, (query: any) => {
    return firestore.set(shapes, query.shape_id, {
      shape_id: query.shape_id,
      shape_pt_lat: query.shape_pt_lat.split(",").map((x: string) => +x),
      shape_pt_lon: query.shape_pt_lon.split(",").map((x: string) => +x),
      shape_pt_sequence: query.shape_pt_sequence
        .split(",")
        .map((x: string) => +x),
      shape_dist_traveled: query.shape_dist_traveled,
    });
  }).then(() => console.timeEnd("parseShapes"));
};

const parseStops = async (db: any) => {
  console.log("started parsing Stops");
  console.time("parseStops");
  const stops = firestore.collection<models.Stop>("stops");
  const query_res = await db.all(`
  SELECT s.*, 
       Group_concat(st.stop_sequence)       AS stop_sequence, 
       Group_concat(st.arrival_timestamp)   AS arrival_times, 
       Group_concat(st.departure_timestamp) AS departure_times, 
       Group_concat(r.route_id)             AS route_ids, 
       Group_concat(t.shape_id)             AS shape_ids, 
       Group_concat(t.trip_id)              AS trip_ids 
  FROM   routes r 
        INNER JOIN trips t 
                ON r.route_id = t.route_id 
        INNER JOIN stop_times st 
                ON t.trip_id = st.trip_id 
        INNER JOIN stops s 
                ON st.stop_id = s.stop_id 
  GROUP  BY s.stop_id; 
  `);

  return Promise.map(query_res, (query: any) => {
    return firestore.set(stops, query.stop_id, {
      ...query,
      stop_sequence: query.stop_sequence.split(",").map((x: string) => +x),
      arrival_times: query.arrival_times.split(",").map((x: string) => +x),
      departure_times: query.departure_times.split(",").map((x: string) => +x),
      route_ids: [...new Set<string>(query.route_ids.split(","))],
      shape_ids: [...new Set<string>(query.shape_ids.split(","))],
      trip_ids: [...new Set<string>(query.trip_ids.split(","))],
    });
  }).then(() => console.timeEnd("parseStops"));
};

const parseTrips = async (db: any) => {
  console.log("started parsing Trips");
  console.time("parseTrips");
  const trips = firestore.collection<models.Trip>("trips");
  const query_res = await db.all(`SELECT * FROM trips`);

  return Promise.map(
    query_res,
    (query: any) => {
      return firestore.set(trips, query.trip_id, {
        ...query,
      });
    },
    { concurrency: 5000 }
  ).then(() => console.timeEnd("parseTrips"));
};

const parsePolylines = async () => {
  console.log("started parsing Polylines");
  console.time("parsePolylines");
  const polylines = firestore.collection<models.Polyline>("polylines");
  const query_res = await genShapeGeoJSON({}, [], []);
  return Promise.map(query_res, (query: any) => {
    return firestore.set(polylines, query.properties.route_id, {
      route_id: query.properties.route_id,
      type: query.type,
      geoJSON: JSON.stringify(query),
    });
  }).then(() => console.timeEnd("parsePolylines"));
};

const flattenTimetable = async (table: any) => {
  const formatted_list: string[] = [];
  const timestamp_list: number[] = [];
  // flatten the object in column major style
  for (let i = 0; i < table.stops[0].trips.length; i++) {
    for (const entry of table.stops) {
      const stop = entry.trips[i];
      if (stop.skipped === true) {
        formatted_list.push(` — `);
        timestamp_list.push(-1);
      } else if (stop.interpolated === true) {
        formatted_list.push(`${stop.formatted_time} •`);
        timestamp_list.push(stop.arrival_timestamp);
      } else {
        formatted_list.push(stop.formatted_time);
        timestamp_list.push(stop.arrival_timestamp);
      }
    }
  }

  return { formatted: formatted_list, timestamps: timestamp_list };
};

const parseTimetables = async () => {
  console.log("started parsing Timetables");
  console.time("parseTimetables");

  const timetable_config = gtfs_timetable.setDefaultConfig(config);
  // get list of all routes
  const routes = (await gtfs.getRoutes({}, [], [])).map(
    (route: any) => route.route_id
  );

  const activity_map: models.Map<string> = {
    weekday: "1111100",
    saturday: "0000010",
    sunday: "0000001",
  };

  // setup firestore collection
  type TableRoute = { route_id: string };
  const timetables_root = firestore.collection<TableRoute>("timetables");

  const promises: Promise<any>[] = [];

  // iterate through routes and the different days
  for (const route of routes) {
    for (const active_days in activity_map) {
      // get forward and backward timetables
      await firestore.set(timetables_root, route, { route_id: route });

      const timetables = firestore.subcollection<models.Timetable, TableRoute>(
        active_days,
        timetables_root
      );

      const pushTable = async (
        routeId: string,
        day: string,
        direction: 0 | 1
      ) => {
        const timetable = (
          await gtfs_timetable.getFormattedTimetablePage(
            `${routeId}|${day}|${direction}`,
            timetable_config
          )
        )[0];

        if (timetable) {
          const flattened = await flattenTimetable(timetable);
          promises.push(
            firestore.set(timetables(routeId), `${timetable.direction_id}`, {
              route_id: timetable.route_ids[0],
              direction_id: timetable.direction_id,
              direction_name: timetable.direction_name,
              label: timetable.timetable_label,
              start_date: timetable.start_date,
              end_date: timetable.end_date,

              service_id: timetable.service_ids[0],
              include_dates: timetable.calendarDates.includedDates,
              exclude_dates: timetable.calendarDates.excludedDates,

              stops: timetable.stops.map((stop: any) => {
                return {
                  stop_id: stop.stop_id,
                  stop_name: stop.stop_name,
                  stop_lat: stop.stop_lat,
                  stop_lon: stop.stop_lon,
                };
              }),
              formatted: flattened.formatted,
              timestamps: flattened.timestamps,
            })
          );
        }
      };

      try {
        await pushTable(route, activity_map[active_days], 0);
      } catch (error) {
        if (!(error as Error).message.includes("trips")) {
          throw error;
        }
      }
      try {
        await pushTable(route, activity_map[active_days], 1);
      } catch (error) {
        if (!(error as Error).message.includes("trips")) {
          throw error;
        }
      }
    }
  }

  return Promise.all(promises).then(() => console.timeEnd("parseTimetables"));
};

const clearFirestore = async () => {
  console.log("clearing old firestore collections!");
  console.time("clearFirestore");
  const refs = [
    "agency",
    "calendar",
    "routes",
    "stops",
    "polylines",
    "shapes",
    "trips",
    "timetables",
  ];

  // for (const ref of refs) {
  //   const coll = firestore.collection(ref);
  //   const docs = await firestore.all(coll);
  //   await Promise.map(
  //     docs,
  //     (doc: any) => {
  //       return firestore.remove(coll, doc.ref.id);
  //     },
  //     { concurrency: 500 }
  //   );
  // }
  const db = admin.firestore();
  refs.forEach( async (ref: string)=>{
    const Collection = await db.collection(`${ref}`);
    await db.recursiveDelete(Collection).catch((reason: any) =>{
      console.log(`collection ${ref} failed to delete`);
    });
  });
  console.timeEnd("clearFirestore");
};

export const createIndexes = async (db: any) => {
  console.time("index");

  return Promise.all([
    db.run(
      `DELETE FROM routes WHERE route_short_name NOT IN ("${ACTIVE_ROUTES.join(
        '","'
      )}")`
    ), //("87","286","289","288")
    db.run(
      `DELETE FROM trips WHERE route_id NOT LIKE "${ACTIVE_ROUTES.join(
        '%" AND route_id NOT LIKE "'
      )}%"`
    ), //"87%" AND route_id NOT LIKE "286%" AND route_id NOT...
  ]).then(() => console.timeEnd("index"));
};

export const generateDB = async () => {
  // setup sqlite middle man
  await gtfs.import(config);
  await gtfs.openDb(config);
  const db = await gtfs.getDb();
  await createIndexes(db);

  // do the firestore stuff
  await clearFirestore();
  return Promise.all([
    parseAgency(db),
    parseCalendar(db),
    parseRoutes(db),
    parseStops(db),
    parsePolylines(),
    // parseShapes(db), // unecessary because we have polylines already
    // parseTrips(db),
    parseTimetables(),
  ]);
};

/** function that runs periodically to refresh our database with the latest gtfs data
 * checks if the current date is past what we have data for, then calls [generateDB] if true
 * @effects
 */
export const refreshDataBase = functions
  .runWith(runtimeOpts)
  .pubsub.schedule("0 3 * * *") // run at 3:00 am everyday eastern time
  .timeZone("America/New_York")
  .onRun(async (_context) => {
    const db = admin.firestore();
    const endDates: number[] = [];
    const querySnapshot = await db.collection("routes").get();


    querySnapshot.forEach((doc) => {
      const end_date = doc.get("end_date");
      if (isNumber(end_date)) {
        endDates.push(end_date);
      } else {
        console.log("error bruh");
      }
    });

    endDates.sort();

    const currentDate = new Date();
    const dd = String(currentDate.getDate()).padStart(2, "0");
    const mm = String(currentDate.getMonth() + 1).padStart(2, "0");
    const yyyy = currentDate.getFullYear();
    const today: number = +(yyyy + mm + dd);

    if (endDates[0] <= today) {
      //update needed
      await generateDB();
      fs.unlinkSync(config.sqlitePath);
      console.log("update successful");
      return 0;
    }

    return 0;
  });

// if __name__ == '__main__':
if (require.main === module) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
  });
  generateDB()
    .then(() => console.log("finished updating db"))
    .catch((error) => console.log(error));
}
