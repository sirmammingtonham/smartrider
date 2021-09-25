import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
//import { each } from "lodash";

const runtimeOpts: functions.RuntimeOptions = {
    timeoutSeconds: 540,
    memory: "128MB",
};

export const saferideOrderFlush = functions
    .runWith(runtimeOpts)
    .pubsub.schedule("0 3 * * *") // run at 3:00 am everyday eastern time
    .timeZone("America/New_York")
    .onRun(async (_context) => {
        const db = admin.firestore();
        const snapshot = await db.collection("orders").get();
        for(const doc of snapshot.docs)
        {
            if(doc.data().status === "COMPLETED")
            {
                await doc.ref.delete();
            }
        }
    })