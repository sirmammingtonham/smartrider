//////////////////////////////////////////////
/// saferide backend functions (hypetrack) ///
//////////////////////////////////////////////

import * as functions from "firebase-functions";
import * as hypertrack from "./helpers/hypertrack_util";
import * as admin from "firebase-admin";
import * as firebase from "firebase-admin";

admin.initializeApp(functions.config().firebase);
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
      // await hypertrack.acceptOrder(change, context);
      console.log("acceptOrder: ", change, context);
    } else if (
      beforeStatus === "REACHED_PICKUP" &&
      afterStatus === "STARTED_RIDE"
    ) {
      // await hypertrack.startRide(change, context);
    } else if (beforeStatus !== "COMPLETED" && afterStatus === "COMPLETED") {
      // await hypertrack.endRide(change, context);
    } else if (beforeStatus !== "CANCELLED" && afterStatus === "CANCELLED") {
      // await hypertrack.rejectRide(change, context);
    }
  });

// deleteOrder(require('./testData.json').deleteOrder)
export const srOnDelete = functions.firestore
  .document("orders/{orderId}")
  .onDelete(async (snap, _) => {
    // Get an object representing the document prior to deletion
    const deletedValue = snap.data();
    // await hypertrack.completeTrip(deletedValue.trip_id);
  });

export const srOnCreate = functions.firestore
  .document("orders/{orderId}")
  .onCreate(async (snap, _) => {
    console.log(snap.data());
  });

// export const createTest = functions
//   .runWith(runtimeOpts)
//   .https.onRequest((req, res) => {
//     if (req.method !== "GET") {
//       console.log("Invalid request!");
//       res.status(400);
//       return;
//     }

//     // Add a new document in collection "orders"
//     db.collection("orders").add({
//       name: "ya boiIIIIiiii",
//       vehicle: "Tesla Cybertruck",
//       date: new Date()
//     })
//     .then(() => {
//       console.log("Document successfully written!");
//       res.status(200).json({ message: "Document successfully written!" });
//     })
//     .catch((error) => {
//       console.error("Error writing document: ", error);
//       res.status(500);
//     });
//   });

// http://localhost:5001/<your project name e.g. uber-for-x-58779>/us-central1/onTripUpdate
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

// FirebaseFirestore firestore = FirebaseFirestore.getInstance();
const db = firebase.firestore();