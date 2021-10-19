import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { default as fetch } from "node-fetch";

admin.initializeApp(); // needs to go before other imports: https://github.com/firebase/firebase-functions-test/issues/6#issuecomment-496021884

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 3, // timeout function after 3 secs
  memory: "128MB", // allocate 128MB of mem per function
};
// export { refreshGTFS } from "./gtfs_update_firestore";

// Clears the firestore database of any orders that have not errored
// Runs at 3:00 am everyday eastern time automatically
// export const saferideOrderFlush = functions
//   .runWith(runtimeOpts)
//   .pubsub.schedule("0 3 * * *")
//   .timeZone("America/New_York")
//   .onRun(async (_context) => {
//     const snapshot = await admin.firestore().collection("orders").get();
//     for (const doc of snapshot.docs) {
//       if (doc.data().status !== "ERROR") {
//         await doc.ref.delete();
//       }
//     }
//   });

// Allows bypassing of cors restrictions using a proxy server
// Requires authentication to prevent abuse
export const corsProxy = functions
  .runWith(runtimeOpts)
  .https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "You must be authenticated");
    }
    const url = data.url;
    const r = await fetch(url, { method: data.method });
    if (!r.ok) {
      console.log(r.status);
      return null;
    }
    return r.json();
  });
