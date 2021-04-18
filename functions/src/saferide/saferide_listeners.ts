//////////////////////////////////////////////
/// saferide backend functions (hypetrack) ///
//////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as hypertrack from "./saferide_util";
import * as firebase from "firebase-admin";
import { DocumentSnapshot } from "@google-cloud/firestore";
import { Status, User, Driver } from "./saferide_types";

const firestore = firebase.firestore();

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

/**
 * Accepts order and starts saferide with hypertrack
 * Creates trip to the pickup location
 *
 * @param order A DocumentSnapshot of the order we want to accept
 * @param driver A DocumentSnapshot of the driver we want to assign
 * @effects
 * @returns A promise of the update result, or undefined (so we can track if it was successful)
 */
async function acceptOrder(order: DocumentSnapshot, driver: DocumentSnapshot) {
  console.log('acceptOrder called');
  const orderData = order.data();
  const driverData = driver.data();
  if (!orderData || !driverData) return;

  await driver.ref.update({ available: false });
  await order.ref.update({
    // status: "ACCEPTED",
    driver: { ...driverData, ref: driver.ref },
    updatedAt: firebase.firestore.FieldValue.serverTimestamp(),
  });

  // start by creating trip to pickup locoation
  const parsedBody = await hypertrack.createTrip(
    driverData["device_id"],
    orderData["pickup"]
  );

  console.log(parsedBody);

  if (parsedBody["trip_id"]) {
    return order.ref.set(
      {
        updated_at: firebase.firestore.FieldValue.serverTimestamp(),
        status: "PICKING_UP",
        trip_id: parsedBody["trip_id"],
        estimate: parsedBody["estimate"] ?? null,
      },
      { merge: true }
    );
  } else {
    console.error(`malformed request: ${parsedBody}`);
    return;
  }
}

/**
 * Starts ride from pickup to dropoff of the order
 * Completes trip to the pickup location, starts trip to dropoff location
 *
 * @param order A DocumentSnapshot of the order we want to start the ride
 * @effects
 * @returns A promise of the update result, or undefined (so we can track if it was successful)
 */
async function startRide(order: DocumentSnapshot) {
  console.log('startRide called');
  const orderData = order.data();
  if (!orderData) return;

  await hypertrack.completeTrip(orderData["trip_id"]); // complete previous trip (saferide going to pickup)
  const parsedBody = await hypertrack.createTrip(
    // create new trip to dropoff
    orderData["driver"]["device_id"],
    orderData["dropoff"]
  );

  if (parsedBody["trip_id"]) {
    return order.ref.set(
      {
        updated_at: firebase.firestore.FieldValue.serverTimestamp(),
        status: "DROPPING_OFF",
        trip_id: parsedBody["trip_id"],
        estimate: parsedBody["estimate"],
      },
      { merge: true }
    );
  } else {
    console.error(`malformed request: ${parsedBody}`);
    return;
  }
}

/**
 * Completes a ride
 *
 * @param order A DocumentSnapshot of the order we want to complete
 * @effects
 * @returns A promise of the driver update or undefined
 */
async function completeRide(order: DocumentSnapshot) {
  console.log('completeRide called');
  const orderData = order.data();
  if (!orderData) return;

  await hypertrack.completeTrip(orderData.trip_id);
  await order.ref.delete();
  return orderData["driver"]["ref"].update({ available: true });
}

/**
 * Rejects a ride
 * (currently same as completeRide, but we might want different functionality so making this its own func for now)
 *
 * @param order A DocumentSnapshot of the order we want to reject
 * @effects
 * @returns A promise of the driver update or undefined
 */
async function rejectRide(order: DocumentSnapshot) {
  console.log('rejectRide called');
  const orderData = order.data();
  if (!orderData) return;

  await hypertrack.completeTrip(orderData.trip_id);
  await order.ref.delete();
  return orderData["driver"]["ref"].update({ available: true });
}

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
      .where("status", "in", ["PICKING_UP", "REACHED_PICKUP", "DROPPING_OFF"]);

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
      /// order status changed to accepted (before it would just call hypertrack and change status to picking_up so not really a point anymore. Unless we want custom logic...)
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

// Updates earliest order to accepted if a driver is available
export const onDriverUpdate = functions
  .runWith(runtimeOpts)
  .firestore.document("drivers/{driver_id}")
  .onUpdate(async (change, _context) => {
    console.log("srOnDriverUpdate was called");

    const before = change.before.data();
    const after = change.after.data();

    if (before.available === false && after.available === true) {
      console.log("Driver: " + after.deviceId + " is now available");

      const earliestOrderQuery = firestore
        .collection("orders")
        .where("status", "==", "NEW")
        .orderBy("created_at", "asc")
        .limit(1);

      const snap = await earliestOrderQuery.get();
      if (snap.docs.length > 0) {
        await acceptOrder(snap.docs[0], change.after);
      }
    }
  });
