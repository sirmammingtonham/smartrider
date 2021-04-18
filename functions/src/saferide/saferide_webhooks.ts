import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const firestore = admin.firestore();

const runtimeOpts: functions.RuntimeOptions = {
	timeoutSeconds: 3, // timeout function after 2 secs
	memory: "256MB", // allocate 256MB of mem per function
  };

// http://localhost:5001/<your project name e.g. uber-for-x-58779>/us-central1/onTripUpdate
// webhook used by hypertrack to update order status, shouldn't get called from app
export const hypertrackTripWebhook = functions
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
