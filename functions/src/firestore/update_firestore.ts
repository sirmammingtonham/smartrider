import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as gtfs from "gtfs";
import * as gtfs_timetable from "gtfs-to-html";
import * as models from "./firestore_types";
import * as Promise from "../helpers/async_util";
// import * as config from "../setup/gtfs_config.json";
import * as serviceAccount from "../setup/smartrider-4e9e8-service.json";
import { collection, subcollection, set, all, remove } from "typesaurus";
import { genShapeGeoJSON } from "../helpers/bus_util";
import { zipObject, zip, isNumber } from "lodash";
import * as fs from "fs";
import * as os from "os";

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});

const config = {
  "agencies": [
    {
      "agency_key": "cdta",
      "url": "https://www.cdta.org/schedules/google_transit.zip",
      "exclude": []
    }
  ],
  "sqlitePath": os.tmpdir + '/gtfs.db',
  "csvOptions": {
    "skip_lines_with_error": true
  },
  "coordinatePrecision": 5,
  "showMap": false
};
const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 540,
  memory: "2GB",
};

const createDbFile = (filePath: string) => {

  fs.appendFile(filePath, '', function (err) {
    if (err) {
      console.log('error occured while creating gtfs db file')
    }

    else {
      console.log('gtfs db file created!');
    }
  });
}
// admin.initializeApp({ projectId: "smartrider-4e9e8" }); // uncomment to test in emulator

console.log("initialized");

const parseAgency = async (db: any) => {
  console.log("started parsing Agency");
  console.time("parseAgency");
  const agency = collection<models.Agency>("agency");
  const query_res = await db.all(`SELECT * FROM agency`);
  return Promise.map(query_res, (query: any) => {
    return set(agency, query.agency_id, {
      agency_id: query.agency_id,
      agency_name: query.agency_name,
      agency_url: query.agency_url,
      agency_timezone: query.agency_timezone,
      agency_lang: query.agency_lang,
      agency_phone: query.agency_phone,
      agency_fare_url: query.agency_fare_url,
      agency_email: query.agency_email,
    });
  }).then(() => console.timeEnd("parseAgency"));
};

const parseCalendar = async (db: any) => {
  console.log("started parsing Calendar");
  console.time("parseCalendar");
  const calendar = collection<models.Calendar>("calendar");
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
    return set(calendar, query.service_id, {
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
  const routes = collection<models.Route>("routes");
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

    return set(routes, query.route_id, {
      route_id: query.route_id,
      agency_id: query.agency_id,
      route_short_name: query.route_short_name,
      route_long_name: query.route_long_name,
      route_desc: query.route_desc,
      route_type: +query.route_type,
      route_url: query.route_url,
      route_color: query.route_color,
      route_text_color: query.route_text_color,
      route_sort_order: +query.route_sort_order,
      continuous_pickup: query.continuous_pickup,
      continuous_drop_off: query.continuous_drop_off,

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
          stop_id: curStop.stop_id,
          stop_name: curStop.stop_name,
          stop_lat: curStop.stop_lat,
          stop_lon: curStop.stop_lon,
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
  const shapes = collection<models.Shape>("shapes");
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
    return set(shapes, query.shape_id, {
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
  const stops = collection<models.Stop>("stops");
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
    return set(stops, query.stop_id, {
      stop_id: query.stop_id,
      stop_code: query.stop_code,
      stop_name: query.stop_name,
      stop_desc: query.stop_desc,
      stop_lat: query.stop_lat,
      stop_lon: query.stop_lon,
      zone_id: query.zone_id,
      stop_url: query.stop_url,
      location_type: query.location_type,
      parent_station: query.parent_station,
      stop_timezone: query.stop_timezone,
      wheelchair_boarding: query.wheelchair_boarding,
      leved_id: query.leved_id,
      platform_code: query.platform_code,
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
  const trips = collection<models.Trip>("trips");
  const query_res = await db.all(`SELECT * FROM trips`);

  return Promise.map(
    query_res,
    (query: any) => {
      return set(trips, query.trip_id, {
        trip_id: query.trip_id,
        route_id: query.route_id,
        service_id: query.service_id,
        trip_headsign: query.trip_headsign,
        trip_short_name: query.trip_short_name,
        direction_id: query.direction_id,
        block_id: query.block_id,
        shape_id: query.shape_id,
        wheelchair_accessible: query.wheelchair_accessible,
        bikes_allowed: query.bikes_allowed,
      });
    },
    { concurrency: 5000 }
  ).then(() => console.timeEnd("parseTrips"));
};

const parsePolylines = async () => {
  console.log("started parsing Polylines");
  console.time("parsePolylines");
  const polylines = collection<models.Polyline>("polylines");
  const query_res = await genShapeGeoJSON({}, [], []);
  return Promise.map(query_res, (query: any) => {
    return set(polylines, query.properties.route_id, {
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
      // stop_list.push({
      //   arrival_time: stop.arrival_timestamp,
      //   stop_id: stop.stop_id,
      //   formatted_time: stop.formatted_time,
      //   stop_sequence: stop.stop_sequence,

      //   interpolated: stop.interpolated ? stop.interpolated : false,
      //   skipped: stop.skipped ? stop.skipped : false,
      // });
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

const parseTest = async () => {
  const timetable_config = gtfs_timetable.setDefaultConfig(config);

  const table_f = (
    await gtfs_timetable.getFormattedTimetablePage(
      `87-185|1111100|0`,
      timetable_config
    )
  )[0];

  const flat = await flattenTimetable(table_f);

  fs.writeFileSync(
    "out.json",
    JSON.stringify({
      route_id: table_f.route_ids[0],
      direction_id: table_f.direction_id,
      direction_name: table_f.direction_name,
      label: table_f.timetable_label,
      start_date: table_f.start_date,
      end_date: table_f.end_date,

      service_id: table_f.service_ids[0],
      include_dates: table_f.calendarDates.includedDates,
      exclude_dates: table_f.calendarDates.excludedDates,

      stops: table_f.stops.map((stop: any) => {
        return {
          stop_id: stop.stop_id,
          stop_name: stop.stop_name,
          stop_lat: stop.stop_lat,
          stop_lon: stop.stop_lon,
        };
      }),
      timetable: flat,
    })
  );
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
  const timetables_root = collection<TableRoute>("timetables");

  const promises = [];

  // iterate through routes and the different days
  for (const route of routes) {
    for (const active_days in activity_map) {
      // get forward and backward timetables
      let table_f: any;
      let table_b: any;
      await set(timetables_root, route, { route_id: route });

      const timetables = subcollection<models.Timetable, TableRoute>(
        active_days,
        timetables_root
      );

      try {
        table_f = (
          await gtfs_timetable.getFormattedTimetablePage(
            `${route}|${activity_map[active_days]}|0`,
            timetable_config
          )
        )[0];

        const f_timetables = await flattenTimetable(table_f);
        promises.push(
          set(timetables(route), `${table_f.direction_id}`, {
            route_id: table_f.route_ids[0],
            direction_id: table_f.direction_id,
            direction_name: table_f.direction_name,
            label: table_f.timetable_label,
            start_date: table_f.start_date,
            end_date: table_f.end_date,

            service_id: table_f.service_ids[0],
            include_dates: table_f.calendarDates.includedDates,
            exclude_dates: table_f.calendarDates.excludedDates,

            stops: table_f.stops.map((stop: any) => {
              return {
                stop_id: stop.stop_id,
                stop_name: stop.stop_name,
                stop_lat: stop.stop_lat,
                stop_lon: stop.stop_lon,
              };
            }),

            formatted: f_timetables.formatted,
            timestamps: f_timetables.timestamps,
          })
        );
      } catch (error) {
        // console.log(error);
        console.log(`NO TRIPS FOR: ${route}|${activity_map[active_days]}|0`);
      }
      try {
        table_b = (
          await gtfs_timetable.getFormattedTimetablePage(
            `${route}|${activity_map[active_days]}|1`,
            timetable_config
          )
        )[0];

        const b_timetables = await flattenTimetable(table_b);
        promises.push(
          set(timetables(route), `${table_b.direction_id}`, {
            route_id: table_b.route_ids[0],
            direction_id: table_b.direction_id,
            direction_name: table_b.direction_name,
            label: table_b.timetable_label,
            start_date: table_b.start_date,
            end_date: table_b.end_date,

            service_id: table_b.service_ids[0],
            include_dates: table_b.calendarDates.includedDates,
            exclude_dates: table_b.calendarDates.excludedDates,

            stops: table_f.stops.map((stop: any) => {
              return {
                stop_id: stop.stop_id,
                stop_name: stop.stop_name,
                stop_lat: stop.stop_lat,
                stop_lon: stop.stop_lon,
              };
            }),

            formatted: b_timetables.formatted,
            timestamps: b_timetables.timestamps,
          })
        );
      } catch (error) {
        console.log(`NO TRIPS FOR: ${route}|${activity_map[active_days]}|1`);
      }

      // if (table_f === undefined || table_b === undefined) {
      //   console.log(`NO TRIPS FOR: ${route}|${activity_map[active_days]}`);
      //   continue;
      // }
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

  for (const ref of refs) {
    const coll = collection(ref);
    const docs = await all(coll);
    await Promise.map(
      docs,
      (doc: any) => {
        return remove(coll, doc.ref.id);
      },
      { concurrency: 500 }
    );
  }
  console.timeEnd("clearFirestore");
};

const createIndexes = async (db: any) => {
  console.time("index");
  return Promise.all([
    db.run(`CREATE INDEX r_id ON routes(route_id)`),
    db.run(`CREATE INDEX r_id2 ON trips(route_id)`),
    db.run(`CREATE INDEX t_id ON trips(trip_id)`),
    db.run(`CREATE INDEX t_id2 on stop_times(trip_id)`),
    db.run(`CREATE INDEX s_id ON stop_times(stop_id)`),
    db.run(`CREATE INDEX s_id2 ON stops(stop_id)`),
    db.run(`CREATE INDEX sr_id ON calendar(service_id)`),
    db.run(`CREATE INDEX sr_id2 ON trips(service_id)`),
  ]).then(() => console.timeEnd("index"));
};

const generateDB = async () => {
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
    parseShapes(db),
    parseTrips(db),
    parseTimetables(),
    // parseTest(),
  ]);
};


export const refreshDataBase = functions.runWith(runtimeOpts).pubsub.schedule('0 3 * * *')  // run at 3:00 am everyday eastern time
  .timeZone('America/New_York')
  .onRun((context) => {
    const db = admin.firestore();
    const enddates: number[] = [];

    db.collection("routes").get().then((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        const end_date = doc.get('end_date');
        if (isNumber(end_date)) {
          enddates.push(end_date);
        }
        else {
          console.log("error bruh");
        }
      });

      enddates.sort();

      const currentDate = new Date();
      const dd = String(currentDate.getDate()).padStart(2, '0');
      const mm = String(currentDate.getMonth() + 1).padStart(2, '0');
      const yyyy = currentDate.getFullYear();
      const today: number = +(yyyy + mm + dd);

      if (enddates[0] <= today) { //update needed
        const dbPath = os.tmpdir() + '/gtfs.db';
        createDbFile(dbPath);
        generateDB().then(() => {
          try {
            fs.unlinkSync(dbPath)
            console.log("update successful")
          }
          catch (error) {
            console.log("error deleting tmp file");
          }
        }).catch((error) => {
          console.log(error);
        });
      }
      else {  //update not needed
        console.log("no update needed");
      }
    }).catch((error) => console.log(error));
  });

// console.time("generateDB");
// generateDB()
//   .then(() => {
//     console.timeEnd("generateDB");
//   })
//   .catch((error) => console.error(error));
