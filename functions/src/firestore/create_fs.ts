import * as admin from "firebase-admin";
import * as gtfs from "gtfs";
import * as models from "./fs_types";
import * as Promise from "../helpers/async_util";
import * as config from "../setup/gtfs_config.json";
import * as serviceAccount from "../setup/smartrider-4e9e8-service.json";
import { collection, subcollection, set, all, remove } from "typesaurus";
import { genShapeGeoJSON } from "../helpers/bus_util";
import { zipObject } from "lodash";

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});

console.log('initialized');

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
  Group_concat(t.trip_id)  AS trip_id, 
  Group_concat(t.shape_id) AS shape_id, 
  Group_concat(s.stop_id)  AS stop_id 
  FROM   routes r 
    INNER JOIN trips t 
            ON r.route_id = t.route_id 
    INNER JOIN stop_times st 
            ON t.trip_id = st.trip_id 
    INNER JOIN stops s 
            ON st.stop_id = s.stop_id 
  GROUP  BY r.route_id; 
  `);
  return Promise.map(query_res, (query: any) => {
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
      trip_ids: [...new Set<string>(query.trip_id.split(","))],
      shape_ids: [...new Set<string>(query.shape_id.split(","))],
      stop_ids: [...new Set<string>(query.stop_id.split(","))],
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
  Group_concat(st.departure_timestamp) AS departure_times 
  FROM   stop_times st 
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

const parseTimetables = async (db: any) => {
  console.log("started parsing Timetables");
  console.time("parseTimetables");
  type TableRoute = { route_id: string };
  const timetables_root = collection<TableRoute>("timetables");
  const query_res = await db.all(`
  SELECT r.route_id, 
       c.*, 
       s.stop_id, 
       s.stop_name, 
       s.stop_lat, 
       s.stop_lon, 
       st.arrival_timestamp, 
       st.stop_sequence 
  FROM   routes r 
        INNER JOIN trips t 
                ON r.route_id = t.route_id 
        INNER JOIN calendar c 
                ON c.service_id = t.service_id 
        INNER JOIN stop_times st 
                ON t.trip_id = st.trip_id 
        INNER JOIN stops s 
                ON st.stop_id = s.stop_id
  ORDER  BY r.route_id, 
            s.stop_id, 
            st.arrival_timestamp 
  `);

  const stop_map = new Map();
  query_res.forEach((query: any) => {
    let obj; // stores stop info in the stop_map
    if ((obj = stop_map.get(query.stop_id))) {
      obj.stop_times.push(query.arrival_timestamp);
    } else {
      stop_map.set(query.stop_id, {
        route_id: query.route_id,
        active_days: {
          monday: !!query.monday,
          tuesday: !!query.tuesday,
          wednesday: !!query.wednesday,
          thursday: !!query.thursday,
          friday: !!query.friday,
          saturday: !!query.saturday,
          sunday: !!query.sunday,
        },
        stop_id: query.stop_id,
        stop_name: query.stop_name,
        service_id: query.service_id,
        stop_lat: query.stop_lat,
        stop_lon: query.stop_lon,
        stop_sequence: query.stop_sequence,
        stop_times: [query.arrival_timestamp],
      });
    }
  });

  const route_map = new Map();
  for (const [_, stop] of stop_map.entries()) {
    if (!route_map.has(stop.route_id)) {
      route_map.set(stop.route_id, {
        monday: [],
        tuesday: [],
        wednesday: [],
        thursday: [],
        friday: [],
        saturday: [],
        sunday: [],
      });
    }
    let table = route_map.get(stop.route_id);
    for (const [day, value] of Object.entries(stop.active_days)) {
      if (value) {
        table[day].push({
          stop_id: stop.stop_id,
          stop_name: stop.stop_name,
          service_id: stop.service_id,
          stop_lat: stop.stop_lat,
          stop_lon: stop.stop_lon,
          stop_sequence: stop.stop_sequence,
          stop_times: stop.stop_times,
        });
      }
    }
  }
  const promises = [];
  for (const [route_id, timetable] of route_map.entries()) {
    await set(timetables_root, route_id, { route_id: route_id });
    for (const [day, stops] of Object.entries(timetable)) {
      const timetables = subcollection<models.Timetable, TableRoute>(
        day,
        timetables_root
      );
      for (const stop of stops as any) {
        promises.push(
          set(timetables(route_id), stop.stop_id, {
            stop_id: stop.stop_id,
            stop_name: stop.stop_name,
            service_id: stop.service_id,
            stop_lat: stop.stop_lat,
            stop_lon: stop.stop_lon,
            stop_sequence: stop.stop_sequence,
            stop_times: stop.stop_times,
          })
        );
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

  for (const ref of refs) {
    const coll = collection(ref);
    const docs = await all(coll);
    await Promise.map(
      docs,
      (doc: any) => {
        return remove(coll, doc.ref.id);
      },
      { concurrency: 1000 }
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
  // await clearFirestore();
  return Promise.all([
    parseAgency(db),
    parseCalendar(db),
    parseRoutes(db),
    parseStops(db),
    parsePolylines(),
    parseShapes(db),
    parseTrips(db),
    parseTimetables(db),
  ]);
};

console.time("generateDB");
generateDB()
  .then(() => {
    console.timeEnd("generateDB");
  })
  .catch((error) => console.error(error));
