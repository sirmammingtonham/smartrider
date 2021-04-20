import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const firestore = admin.firestore();

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 2 secs
};

// webhook used by hypertrack to update order status, shouldn't get called from app
export const hypertrackTripWebhook = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    const data = JSON.parse(req.rawBody.toString());
    console.log("onTripUpdate:data: " + JSON.stringify(data));
    for (const event of data) {
      console.log("onTripUpdate:event: " + JSON.stringify(event));
      if (event.type === "trip" && event.data.value === "destination_arrival") {
        const querySnapshot = await firestore
          .collection("orders")
          .where("trip_id", "==", event.data.trip_id)
          .limit(1)
          .get();

        for (const doc of querySnapshot.docs) {
          console.log(
            "onTripUpdate:doc.data: " +
              doc.id +
              " - " +
              JSON.stringify(doc.data())
          );
          if (doc.data().status === "PICKING_UP") {
            await doc.ref.update({ status: "REACHED_PICKUP" });
          } else if (doc.data().status === "DROPPING_OFF") {
            await doc.ref.update({ status: "REACHED_DROPOFF" });
          }
        }
      }
    }
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    res.send("I ♥ HyperTrack");
  });
