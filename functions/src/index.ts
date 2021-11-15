import * as admin from "firebase-admin";
import { FirebaseError } from "firebase-admin";
import * as functions from "firebase-functions";
import * as xml2js from "xml2js";
import { default as fetch } from "node-fetch";

admin.initializeApp(); // needs to go before other imports: https://github.com/firebase/firebase-functions-test/issues/6#issuecomment-496021884

const parser = new xml2js.Parser();
const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 60, // timeout function after 3 secs
  memory: "128MB", // allocate 128MB of mem per function
};

const CAS_ENDPOINT = `https://casserver.herokuapp.com/cas`;
const BUNDLE_ID = "io.rcos.smartrider";
const IOS_MIN_VERSION = "0.0.1";
const ANDROID_MIN_VERSION = "0.0.1";
const EFR = 1;

const getDynamicLink = (deepUrl: String) =>
  `https://smartrider.page.link/?link=${deepUrl}&apn=${BUNDLE_ID}&amv=${ANDROID_MIN_VERSION}&ibi=${BUNDLE_ID}&imv=${IOS_MIN_VERSION}&efr=${EFR}`;

// export { refreshGTFS } from "./gtfs/gtfs_update_firestore";

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
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be authenticated"
      );
    }
    const url = data.url;
    const r = await fetch(url, { method: data.method });
    if (!r.ok) {
      console.log(r.status);
      return null;
    }
    return r.json();
  });

export const casAuthenticate = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    const ORIGIN = `${req.protocol}://${req.get(
      "Host"
    )}/smartrider-4e9e8/us-central1/casAuthenticate`;

    if (req.query.ticket === undefined || req.query.ticket === null) {
      return res.redirect(`${CAS_ENDPOINT}/login?service=${ORIGIN}`);
    }

    const params = new URLSearchParams({
      ticket: req.query.ticket as string,
      service: ORIGIN,
    }).toString();

    try {
      const r = await fetch(`${CAS_ENDPOINT}/serviceValidate?${params}`);
      const xml = await r.text();

      const result = await parser.parseStringPromise(xml);

      const casAttributes =
        result["cas:serviceResponse"]["cas:authenticationSuccess"]["0"][
          "cas:attributes"
        ]["0"];
      const uid = casAttributes["cas:uid"][0];
      // const displayName = casAttributes['cas:displayName'][0];
      // const email = casAttributes['cas:mailLocalAddress'][0];
      // const rin = casAttributes['cas:rpiRIN'][0];

      const token = await admin.auth().createCustomToken(uid);
      const payload = new URLSearchParams({
        token,
        uid,
        // displayName,
        // email,
        // rin,
      }).toString();

      await admin.firestore().doc(`users/${uid}`).set(
        {
          uid,
          displayName: "Ethan Joseph",
          email: "josepe2@rpi.edu",
          rin: "1680981215",
        },
        { merge: true }
      );

      const deepUrl = `https://smartrider.page.link/casAuth?${encodeURIComponent(
        payload
      )}`;
      console.log(deepUrl);
      return res.redirect(getDynamicLink(deepUrl));
    } catch (e: any) {
      const payload = new URLSearchParams({
        ...e.errorInfo,
      }).toString();
      return res.redirect(
        getDynamicLink(
          `https://smartrider.page.link/casAuthFail?${encodeURIComponent(
            payload
          )}`
        )
      );
    }
  });
