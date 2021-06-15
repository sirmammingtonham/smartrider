// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// // import {dean} from "../setup/keys.json";
// import {ethan} from "../setup/keys.json";

// const firestore = admin.firestore();

// const runtimeOpts: functions.RuntimeOptions = {
//   timeoutSeconds: 3, // timeout function after 2 secs
//   memory: "256MB", // allocate 256MB of mem per function
// };

// export const addTestDriver = functions
//   .runWith(runtimeOpts)
//   .https.onRequest(async (req, res) => {
//     if (req.method !== "GET") {
//       console.log("Invalid request!");
//       res.status(400);
//       return;
//     }

//     // await firestore.collection("drivers").add({
//     //   device_id: dean,
//     //   name: "Dean",
//     //   phone: "8888888888",
//     //   email: "lioanj@rpi.edu",
//     //   available: true,
//     //   license_plate: "XYZ-1234"
//     // });
//     await firestore.collection("drivers").add({
//       device_id: ethan,
//       name: "Ethan",
//       phone: "8888888888",
//       email: "lioanj@rpi.edu",
//       available: true,
//       license_plate: "XYZ-1234"
//     });

//     res.send("test ting");
//   });

//   // kind of a worse case when 20 users try to call a saferide at the same time
// export const createTest = functions
// .runWith(runtimeOpts)
// .https.onRequest(async (req, res) => {
//   if (req.method !== "GET") {
// 	console.log("Invalid request!");
// 	res.status(400);
// 	return;
//   }

//   // Add a new document in collection "orders"
//   for (let i = 0; i < 20; i++) {
// 	await firestore.collection("orders").add({
// 	  name: "ya boiIIIIiiii",
// 	  vehicle: "Tesla Cybertruck",
// 	  created_at: new Date(1975 + 2 * i, i % 12, 28 - i),
// 	  status: "NEW",
// 	});
//   }
//   for (let i = 0; i < 3; i++) {
// 	await firestore.collection("drivers").add({
// 	  id: `${145 * i + 234}`,
// 	  email: "joe@mama.org",
// 	  available: false,
// 	});
//   }
//   res.send("teststest");
// });