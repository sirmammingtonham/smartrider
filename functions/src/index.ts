import * as functions from "firebase-functions";
import * as gtfs from "gtfs";

const config = {
  sqlitePath: "./gtfs.db"
};
gtfs
  .openDb(config)
  .then(() => {
    console.log("Database loaded");
  })
  .catch((err: any) => {
    console.log("openDb error: " + err);
  });

// needed to create the db file, shouldnt be used otherwise!
// import * as config from "../config.json";
// gtfs.import(config).then(() => {
//   gtfs.openDb(config).then(() => {
//     gtfs.closeDb().then(() => {
//       console.log("finished");
//     });
//   });
// });

export const helloWorld = functions.https.onRequest((req, res) => {
  // return error status if method isn't GET
  if (req.method !== "GET") {
    console.log("Invalid request!");
    res.sendStatus(400);
    return;
  }

  console.log("Hello logs!");
  res.status(200).json({ message: "Hello from smartrider!" });
});

export const busRoutes = functions.https.onRequest((req, res) => {
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

export const busStops = functions.https.onRequest((req, res) => {
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

export const busStoptimes = functions.https.onRequest((req, res) => {
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

export const busShapes = functions.https.onRequest((req, res) => {
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