//////////////////////////////////////////////
/// saferide backend functions (hypetrack) ///
//////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as firebase from "firebase-admin";
import { DocumentSnapshot } from "@google-cloud/firestore";
import { Status, User, Driver } from "./saferide_types";

const firestore = firebase.firestore();

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 10, // timeout function after 2 secs
};

/**
 * This function updates all the orders by counting their position in queue and setting it (expensive)
 * Possible future idea: add every order as point on trip when they come in to get a good estimate
 * ALso might be better to only run this when an order is deleted.
 * We can store metadata about this in a different document for when an order is created.
 *
 * @effects
 */
async function updateOrderEstimates() {
  console.log("running expensive update order estimate!");
  // run in transaction to prevent concurrent calls from changing results
  return firestore.runTransaction(async (transaction) => {
    const runningOrderQuery = firestore
      .collection("orders")
      .where("status", "in", ["PICKING_UP", "DROPPING_OFF"]);

    const runningOrders = await transaction.get(runningOrderQuery);

    let waitEstimateTotal = 0;
    for (const doc of runningOrders.docs) {
      waitEstimateTotal += doc.data()["estimate"]?.["remaining_duration"] ?? 0;
    } // we should really determine the avg of the waitEstimate (gonna just say it's 5 for now)

    const earliestOrderQuery = firestore
      .collection("orders")
      .where("status", "==", "NEW")
      .orderBy("created_at", "asc");

    const earliestOrders = await transaction.get(earliestOrderQuery);
    for (const [index, doc] of earliestOrders.docs.entries()) {
      transaction.update(doc.ref, {
        queue_position: index + 1,
        wait_estimate: waitEstimateTotal + index * 5,
      });
    }
  });
}

export const onOrderUpdate = functions
  .runWith(runtimeOpts)
  .firestore.document("orders/{order_id}")
  .onWrite(async (change, _context) => {
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
    } else if (beforeStatus === "NEW" && afterStatus === "PICKING_UP") {
      /// driver finished previous trip, is now picking up user
    } else if (
      beforeStatus !== "REACHED_PICKUP" &&
      afterStatus === "REACHED_PICKUP"
    ) {
      /// driver reached user, ride started
      await startRide(change.after);
    } else if (
      beforeStatus !== "REACHED_DROPOFF" &&
      afterStatus === "REACHED_DROPOFF"
    ) {
      /// driver reached dropoff, ride ending
      await completeRide(change.after);
    } else if (beforeStatus !== "CANCELLED" && afterStatus === "CANCELLED") {
      /// order cancelled
      await rejectRide(change.after);
    } else if (beforeStatus && !afterStatus) {
      /// order was deleted (don't want this to do anything rn because it gets called after completeRide and rejectRide)
    }

    // i'm nervous about putting this here because it will run A LOT (we should really limit the size of the orders queue!)
    await updateOrderEstimates();
  });