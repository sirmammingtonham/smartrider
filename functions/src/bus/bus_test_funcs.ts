import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as gtfs from "gtfs";
import * as gtfs_timetable from "gtfs-to-html";
import * as models from "./bus_types";
import * as Promise from "../util/async_util";
import * as firestore from "typesaurus";
import * as serviceAccount from "../setup/smartrider-4e9e8-service.json";
import { genShapeGeoJSON } from "./bus_util";
import { zipObject, zip, isNumber } from "lodash";
import * as fs from "fs";
import * as os from "os";
// import { mainModule } from "node:process";
import { QueryDocumentSnapshot } from "@google-cloud/firestore";

// import * as gtfs from "gtfs";
// import * as gtfs_timetable from "gtfs-to-html";
// import * as fs from 'fs';
// const config = {
//   agencies: [
//     {
//       agency_key: "cdta",
//       url: "https://www.cdta.org/schedules/google_transit.zip",
//       exclude: [],
//     },
//   ],
//   sqlitePath: "./gtfs.db",
//   csvOptions: {
//     skip_lines_with_error: true,
//   },
//   coordinatePrecision: 5,
//   showMap: false,
// };

// const runtimeOpts: functions.RuntimeOptions = {
//   timeoutSeconds: 540, // timeout function after 2 secs
//   memory: "256MB", // allocate 256MB of mem per function
// };

// export const testDB = functions
//   .runWith(runtimeOpts)
//   .https.onRequest(async (req, res) => {
//     if (req.method !== "GET") {
//       console.log("Invalid request!");
//       res.status(400);
//       return;
//     }
// 	// await gtfs.import(config);
// 	// await gtfs.openDb(config);
// 	// const timetable_config = gtfs_timetable.setDefaultConfig(config);
//   // const idk = await gtfs_timetable.getTimetablePages(timetable_config);
// 	// fs.writeFile('./timetable.json', JSON.stringify(idk), () => console.log('wrote'));
// 	// console.log(JSON.stringify(idk[0]));
//   });

const testfunct = async () => {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
      });
    const db = admin.firestore();
    
    const reffs = [
        "test1",
        "test2"
      ];
      reffs.forEach( async (ref: string)=>{
        const Collection = await db.collection(`${ref}`);
        console.log(`${ref}`);
        await db.recursiveDelete(Collection);
      });
    // timetableSnapshot.docs.forEach((value: QueryDocumentSnapshot)=>{
    //     console.log(value.data());
    // })
    // console.log(timetableSnapshot.empty);
    console.log("bruhhhhh");
}
testfunct().then;

