import * as admin from 'firebase-admin';
import * as functions from "firebase-functions";
import * as cors_proxy from 'cors-anywhere';

admin.initializeApp(); // needs to go before other imports: https://github.com/firebase/firebase-functions-test/issues/6#issuecomment-496021884
const firestore = admin.firestore();

const runtimeOpts: functions.RuntimeOptions = {
    timeoutSeconds: 3, // timeout function after 3 secs
    memory: "128MB", // allocate 128MB of mem per function
};

const proxy = cors_proxy.createServer({
    removeHeaders: [
        'cookie',
        'cookie2',
    ],
});

export { refreshGTFS } from './gtfs_update_firestore';

// Clears the firestore database of any orders that have not errored
// Runs at 3:00 am everyday eastern time automatically
export const saferideOrderFlush = functions
    .runWith(runtimeOpts)
    .pubsub.schedule("0 3 * * *")
    .timeZone("America/New_York")
    .onRun(async (_context) => {
        const snapshot = await firestore.collection("orders").get();
        for (const doc of snapshot.docs) {
            if (doc.data().status !== "ERROR") {
                await doc.ref.delete();
            }
        }
    })

// Allows bypassing of cors restrictions using a proxy server
// TODO: maybe make sure that invocations are only from authenticated users to prevent abuse
export const corsProxy = functions
    .runWith(runtimeOpts)
    .https.onRequest((req, res) => {
    proxy.emit('request', req, res);
});