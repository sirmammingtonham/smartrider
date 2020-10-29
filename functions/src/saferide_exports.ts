//////////////////////////////////////////////
/// saferide backend functions (hypetrack) ///
//////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as hypertrack from "./helpers/hypertrack_util";
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

export const srUpdateOrderStatus = functions.firestore
  .document("orders/{orderId}")
  .onUpdate(async (change, context) => {
    console.log("before: " + JSON.stringify(change.before.data()));
    console.log("after: " + JSON.stringify(change.after.data()));
    const beforeStatus = change.before.data().status;
    const afterStatus = change.after.data().status;

    if (beforeStatus === "NEW" && afterStatus === "ACCEPTED") {
      await hypertrack.acceptOrder(change, context);
    } else if (
      beforeStatus === "REACHED_PICKUP" &&
      afterStatus === "STARTED_RIDE"
    ) {
      await hypertrack.startRide(change, context);
    } else if (beforeStatus !== "COMPLETED" && afterStatus === "COMPLETED") {
      await hypertrack.endRide(change, context);
    } else if (beforeStatus !== "CANCELLED" && afterStatus === "CANCELLED") {
      await hypertrack.rejectRide(change, context);
    }
  });

// deleteOrder(require('./testData.json').deleteOrder)
export const srDelOrder = functions.firestore
  .document("orders/{orderId}")
  .onDelete(async (snap, _) => {
    // Get an object representing the document prior to deletion
    const deletedValue = snap.data();
    await hypertrack.completeTrip(deletedValue.trip_id);
  });

// http://localhost:5001/<your project name e.g. uber-for-x-58779>/us-central1/onTripUpdate
export const srOnTripUpdate = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    const data = JSON.parse(req.rawBody.toString());
    console.log("onTripUpdate:data: " + JSON.stringify(data));
    for (let i = 0; i < data.length; i++) {
      const event = data[i];
      console.log("onTripUpdate:event: " + JSON.stringify(event));
      if (event.type === "trip" && event.data.value === "destination_arrival") {
        let ordersRef = firestore.collection("orders");

        let querySnapshot = await ordersRef
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
