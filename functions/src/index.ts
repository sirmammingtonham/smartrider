import * as functions from "firebase-functions";
import * as gtfs from "gtfs";
import * as GtfsRealtimeBindings from "gtfs-realtime-bindings";
import * as request from "request";

const config = {
  sqlitePath: "./gtfs.db",
};

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 2,  // timeout function after 2 secs
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

export const busStoptimes = functions
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

export const tripUpdates = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }
    const requestSettings = {
      method: "GET",
      url: "http://64.128.172.149:8080/gtfsrealtime/TripUpdates",
      encoding: null,
    };
    request(requestSettings, function (error: any, response: any, body: any) {
      if (!error && response.statusCode === 200) {
        const feed = GtfsRealtimeBindings.transit_realtime.FeedMessage.decode(
          body
        );
        res.status(200).json(feed.entity);
      }
    });
  });

export const vehicleUpdates = functions
  .runWith(runtimeOpts)
  .https.onRequest((req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const requestSettings = {
      method: "GET",
      url: "http://64.128.172.149:8080/gtfsrealtime/VehiclePositions",
      encoding: null,
    };
    request(requestSettings, function (error: any, response: any, body: any) {
      if (!error && response.statusCode === 200) {
        const feed = GtfsRealtimeBindings.transit_realtime.FeedMessage.decode(
          body
        );
        res.status(200).json(feed.entity);
      }
    });
  });
