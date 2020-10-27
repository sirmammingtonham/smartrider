import * as functions from "firebase-functions";
import * as gtfs from "gtfs";
// import * as GtfsRealtimeBindings from "gtfs-realtime-bindings";
// import * as request from "request";
// import {genShapeGeoJSON} from "./genShapeGeoJSON";

const config = {
  sqlitePath: "./gtfs.db",
};

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 2, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

gtfs
  .openDb(config)
  .then(() => {
    console.log("Database loaded");
  })
  .catch((err: any) => {
    console.log("openDb error: " + err);
  });

export const helloWorld = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.sendStatus(400);
      return;
    }

    console.log("Hello logs!");
    res.status(200).json({ message: "Hello from smartrider!" });
  });

export const busRoutes = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const query = JSON.parse(req.header("query") ?? "{}"); // get query, set to empty if null
    const fields = JSON.parse(req.header("fields") ?? "[]");
    const sortBy = JSON.parse(req.header("sortBy") ?? "[]");

    console.log("Bus routes requested!");
    // get routes and send json
    gtfs
      .getRoutes(query, fields, sortBy)
      .then((routes: any) => {
        console.log("Bus routes sent!");
        res.status(200).json(routes);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });
export const busTrips = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const query = JSON.parse(req.header("query") ?? "{}"); // get query, set to empty if null
    const fields = JSON.parse(req.header("fields") ?? "[]");
    const sortBy = JSON.parse(req.header("sortBy") ?? "[]");

    console.log("Bus trip requested!");
    // get routes and send json
    gtfs
      .getTrips(query, fields, sortBy)
      .then((trips: any) => {
        console.log("Bus trip sent!");
        res.status(200).json(trips);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });

export const busStops = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const query = JSON.parse(req.header("query") ?? "{}"); // get query, set to empty if null
    const fields = JSON.parse(req.header("fields") ?? "[]");
    const sortBy = JSON.parse(req.header("sortBy") ?? "[]");

    console.log("Bus stops requested!");
    gtfs
      .getStops(query, fields, sortBy)
      .then((stops: any) => {
        console.log("Bus stops sent!");
        res.status(200).json(stops);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });

export const busStoptimes = functions.https // .runWith(runtimeOpts)
  .onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const query = JSON.parse(req.header("query") ?? "{}"); // get query, set to empty if null
    const fields = JSON.parse(req.header("fields") ?? "[]");
    const sortBy = JSON.parse(req.header("sortBy") ?? "[]");

    console.log("Bus stoptimes requested!");
    gtfs
      .getStoptimes(query, fields, sortBy)
      .then((stoptimes: any) => {
        console.log("Bus stoptimes sent!");
        res.status(200).json(stoptimes);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });

export const busShapes = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const query = JSON.parse(req.header("query") ?? "{}"); // get query, set to empty if null
    const fields = JSON.parse(req.header("fields") ?? "[]");
    const sortBy = JSON.parse(req.header("sortBy") ?? "[]");

    console.log("Bus shapes requested!");
    // get routes and send json
    gtfs
      .getShapes(query, fields, sortBy)
      .then((shapes: any) => {
        console.log("Bus shapes sent!");
        res.status(200).json(shapes);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });

export const busTimetable = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    // const query = JSON.parse(req.header("query") ?? "{}"); // get query, set to empty if null

    const query = {
      route_ids: "('87-184','286-184','289-184')",
      days: "monday = 1",
    }; // test query, eventually allow this to be passed in header

    console.log("Bus timetable requested!");

    const db = await gtfs.getDb();
    
    const query_res = await db.all(`
    SELECT r.route_id, r.route_short_name, r.route_long_name, s.stop_name, s.stop_id, 
      s.stop_lat, s.stop_lon, st.arrival_time, st.stop_sequence, c.service_id
    FROM routes r, trips t, stop_times st, stops s, calendar c
    WHERE r.route_id = t.route_id
    AND c.${query.days}
    AND c.service_id = t.service_id
    AND t.trip_id = st.trip_id
    AND st.stop_id = s.stop_id
    AND r.route_id IN ${query.route_ids}
    ORDER BY r.route_id, s.stop_id, s.arrival_time;`
    );

    let stop_map = new Map();
    query_res.forEach((row: any) => {
      let obj; // stores stop info in the stop_map
      if ((obj = stop_map.get(row.stop_id))) {
        obj.stop_times.push(row.arrival_time);
      } else {
        stop_map.set(row.stop_id, {
          route_id: row.route_id,
          stop_name: row.stop_name,
          service_id: row.service_id,
          stop_lat: row.stop_lat,
          stop_lon: row.stop_lon,
          stop_sequence: row.stop_sequence,
          stop_times: [row.arrival_time],
        });
      }
    });

    let route_map: any = new Object();
    stop_map.forEach((value, _) => {
      let obj; // stores stop info in the stop_map
      if ((obj = route_map[value.route_id])) {
        obj.stops.push(value);
      } else {
        route_map[value.route_id] = {
          stops: [value],
        };
      }
    });

    res.status(200).json(route_map);
  });
