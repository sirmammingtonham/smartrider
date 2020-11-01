////////////////////////////////////////////
/// bus backend functions (gtfs parsing) ///
////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as gtfs from "gtfs";
import * as util from "./helpers/bus_util";

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

const default_query = '{route_id: ["87-184","286-184","289-184"]}';

const gtfs_config = {
  sqlitePath: "./gtfs.db",
};

gtfs
  .openDb(gtfs_config)
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

    const query = JSON.parse(req.header("query") ?? default_query); // get query, set to empty if null
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

    const query = JSON.parse(req.header("query") ?? default_query); // get query, set to empty if null
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

    const query = JSON.parse(req.header("query") ?? default_query); // get query, set to empty if null
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

export const busShapes = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const query = JSON.parse(req.header("query") ?? default_query); // get query, set to empty if null
    const fields = JSON.parse(req.header("fields") ?? "[]");
    const sortBy = JSON.parse(req.header("sortBy") ?? "[]");

    console.log("Bus shapes requested!");
    // get routes and send json
    util
      .genShapeGeoJSON(query, fields, sortBy)
      .then((shapes: any) => {
        console.log("Bus shapes sent!");
        res.status(200).json(shapes);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });

export const busTimetables = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    // const query = JSON.parse(req.header("query") ?? default_query); // get query, set to empty if null

    const query = {
      route_ids: "('87-184','286-184','289-184')",
      days: "monday = 1",
    }; // test query, eventually allow this to be passed in header

    console.log("Bus timetable requested!");

    util
      .genBusTimetable(query)
      .then((timetable: any) => {
        console.log("Bus timetable sent!");
        res.status(200).json(timetable);
      })
      .catch((err: any) => {
        console.error(err);
        res.status(500);
      });
  });
