//////////////////////////////////////////////
/// saferide backend functions (hypetrack) ///
//////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as hypertrack from "./hypertrack_util";
import * as firebase from "firebase-admin";
import { DocumentReference, DocumentSnapshot } from "@google-cloud/firestore";
import { Status } from "./types";
// import { order } from "typesaurus";

// admin.initializeApp(functions.config().firebase);

firebase.initializeApp();

const firestore = firebase.firestore();

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

/**
 * Changes status of order to accepted
 * status = "ACCEPTED"
 * driver = driver
 * updatedAt = firebase.firestore.FieldValue.serverTimestamp() [server time]
 * This should always result in a call to onOrderUpdate's second condition
 */
async function acceptOrder(user: DocumentSnapshot, driver: DocumentSnapshot) {
  await driver.ref.update({ available: false });
  await user.ref.update({
    status: "ACCEPTED",
    driver: driver.data(),
    updatedAt: firebase.firestore.FieldValue.serverTimestamp(),
  });
}

async function updateOrderEstimates() {
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

export const onOrderUpdate = functions.firestore
  .document("orders/{orderId}")
  .onWrite(async (change, context) => {
    console.log("before: " + JSON.stringify(change.before.data()));
    console.log("after: " + JSON.stringify(change.after.data()));
    const beforeStatus: Status = change.before.data()?.status;
    const afterStatus: Status = change.after.data()?.status;

    if (!beforeStatus && afterStatus === "NEW") {
      /// new order was created
      const drivers = await firestore.collection("drivers").get();
      for (const driver of drivers.docs) {
        if (driver.data().available) {
          await acceptOrder(change.after, driver);
        }
      }
    } else if (beforeStatus === "NEW" && afterStatus === "ACCEPTED") {
      /// order was just accepted
      // TODO: add arrival estimate to order when status changes to accepted
      // https://hypertrack.com/docs/references/#references-apis-trips
      // await hypertrack.acceptOrder(change, context);
      console.log("acceptedOrder: ", change, context);
      await updateOrderEstimates();
    } else if (
      beforeStatus === "REACHED_PICKUP" &&
      afterStatus === "STARTED_RIDE"
    ) {
      /// driver reached user, ride started
      // TODO: add polyline to order, display on app
      // await hypertrack.startRide(change, context);
    } else if (
      beforeStatus !== "REACHED_DROPOFF" &&
      afterStatus === "REACHED_DROPOFF"
    ) {
      /// driver reached dropoff, ride ending
      // await hypertrack.endRide(change, context);
    } else if (beforeStatus !== "CANCELLED" && afterStatus === "CANCELLED") {
      /// order cancelled
      // await hypertrack.rejectRide(change, context);
    } else if (beforeStatus && !afterStatus) {
      /// order was deleted
    }
  });

// Updates earliest order to accepted if a driver is available
export const onDriverUpdate = functions.firestore
  .document("drivers/{driverId}")
  .onUpdate(async (change, _context) => {
    const before = change.before.data();
    const after = change.after.data();
    console.log("srOnDriverUpdate was called");
    if (before.available === false && after.available === true) {
      console.log("Driver: " + after.deviceId + " is now available");

      const earliestOrderQuery = firestore
        .collection("orders")
        .where("status", "==", "NEW")
        .orderBy("createdAt", "asc")
        .limit(1);

      const snap = await earliestOrderQuery.get();
      if (snap.docs.length > 0) {
        await acceptOrder(snap.docs[0], change.after);
      }
    }
  });
