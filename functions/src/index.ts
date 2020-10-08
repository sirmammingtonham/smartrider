import * as functions from 'firebase-functions';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

export const helloWorld = functions.https.onRequest((req, res) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
  console.log("Hello logs!");
  res.send("Hello from Firebase!");
});
