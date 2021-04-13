//////////////////////////////////////////////
/// saferide backend functions (hypetrack) ///
//////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as hypertrack from "./util/hypertrack_util";
import * as admin from "firebase-admin";
// import { order } from "typesaurus";

// admin.initializeApp(functions.config().firebase);

admin.initializeApp();

const firestore = admin.firestore();

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

export const srOnOrderUpdate = functions.firestore
  .document("orders/{orderId}")
  .onUpdate(async (change, context) => {
    console.log("before: " + JSON.stringify(change.before.data()));
    console.log("after: " + JSON.stringify(change.after.data()));
    const beforeStatus = change.before.data().status;
    const afterStatus = change.after.data().status;

    if (beforeStatus === "NEW" && afterStatus === "ACCEPTED") {
      await hypertrack.acceptOrder(change, context);
      // TODO: add arrival estimate to order when status changes to accepted
      // https://hypertrack.com/docs/references/#references-apis-trips
      console.log("acceptOrder: ", change, context);
      await updateOrderEstimates();
    } else if (
      beforeStatus === "REACHED_PICKUP" &&
      afterStatus === "STARTED_RIDE"
    ) {
      // TODO: add polyline to order, display on app
      await hypertrack.startRide(change, context);
    } else if (
      beforeStatus !== "REACHED_DROPOFF" &&
      afterStatus === "REACHED_DROPOFF"
    ) {
      await hypertrack.endRide(change, context);
    } else if (beforeStatus !== "CANCELLED" && afterStatus === "CANCELLED") {
      await hypertrack.rejectRide(change, context);
    }
  });

const updateOrderEstimates = async () => {
  console.log("running expensive update order estimate op!");

  const earliestOrderQuery = firestore
    .collection("orders")
    .where("status", "==", "NEW")
    .orderBy("createdAt", "asc");

  const snap = await earliestOrderQuery.get();
  for (const [index, doc] of snap.docs.entries()) {
    await doc.ref.update({
      queue_position: index + 1,
      wait_estimate: index + 1, // try to get a good time estimate from hypertrack, needs more brainstorming! (maybe we have to create trips for every order when they come in to get a good estimate idk)
    });
  }
};

// Updates earliest order to accepted if a driver is available
export const srOnDriverUpdate = functions.firestore
  .document("drivers/{driverId}")
  .onUpdate(async (change, _context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.available === false && after.available === true) {
      console.log("Driver: " + after.device_id + " is now available");

      const earliestOrderQuery = firestore
        .collection("orders")
        .where("status", "==", "NEW")
        .orderBy("createdAt", "asc")
        .limit(1);

      // Changes status of order to accepted
      // status = "accepted"
      // driver = after
      const snap = await earliestOrderQuery.get();
      if (snap.docs.length > 0) {
        const earliestOrderPath = snap.docs[0].ref.path;
        const driverPath = change.after.ref.path;

        await firestore.doc(driverPath).update({ available: false });
        await firestore
          .doc(earliestOrderPath)
          .update({ status: "ACCEPTED", driver: after });
      }
    }
  });

// deleteOrder(require('./testData.json').deleteOrder)
export const srOnDelete = functions.firestore
  .document("orders/{orderId}")
  .onDelete(async (snap, _) => {
    // Get an object representing the document prior to deletion
    const deletedValue = snap.data();
    await hypertrack.completeTrip(deletedValue.trip_id);
  });

export const srOnCreate = functions.firestore
  .document("orders/{orderId}")
  .onCreate(async (snap, _) => {
    console.log(snap.data());
    // this op might be super expensive to run but whatever for now
    await updateOrderEstimates();
  });

export const setDriver = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    const docs = await firestore.collection("drivers").listDocuments();
    await docs[0].update({ available: true });
    res.send("changed driver!!!");
  });

// kind of a worse case when 20 users try to call a saferide at the same time
export const createTest = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }

    // Add a new document in collection "orders"
    for (let i = 0; i < 20; i++) {
      await firestore.collection("orders").add({
        name: "ya boiIIIIiiii",
        vehicle: "Tesla Cybertruck",
        createdAt: new Date(1975 + 2 * i, i % 12, 28 - i),
        status: "NEW",
      });
    }
    for (let i = 0; i < 3; i++) {
      await firestore.collection("drivers").add({
        id: `${145 * i + 234}`,
        email: "joe@mama.org",
        available: false,
      });
    }
    res.send("teststest");
  });

// http://localhost:5001/<your project name e.g. uber-for-x-58779>/us-central1/onTripUpdate
// webhook used by hypertrack to update order status, shouldn't get called from app
export const srOnTripUpdate = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    const data = JSON.parse(req.rawBody.toString());
    console.log("onTripUpdate:data: " + JSON.stringify(data));
    for (const event of data) {
      console.log("onTripUpdate:event: " + JSON.stringify(event));
      if (event.type === "trip" && event.data.value === "destination_arrival") {
        const ordersRef = firestore.collection("orders");

        const querySnapshot = await ordersRef
          .where("trip_id", "==", event.data.trip_id)
          .limit(1)
          .get();
        let status, doc_id: any;
        querySnapshot.forEach((doc) => {
          doc_id = doc.id;
          console.log(
            "onTripUpdate:doc.data: " +
              doc.id +
              " - " +
              JSON.stringify(doc.data())
          );
          if (doc.data().status === "PICKING_UP") {
            status = "REACHED_PICKUP";
          } else if (doc.data().status === "DROPPING_OFF") {
            status = "REACHED_DROPOFF";
          }
        });
        console.log("onTripUpdate:status: " + status);

        if (status) {
          await ordersRef.doc(doc_id).update({
            status: status,
          });
        }
      }
    }
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    res.send("I ♥ HyperTrack");
  });

export const createOrder = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    // return error status if method isn't GET
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }
  });
