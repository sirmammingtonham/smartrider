import { generateDB } from "./update_firestore_gtfs";
import * as functions from "firebase-functions";

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

const runtimeOpts: functions.RuntimeOptions = {
  timeoutSeconds: 540, // timeout function after 2 secs
  memory: "256MB", // allocate 256MB of mem per function
};

export const testDB = functions
  .runWith(runtimeOpts)
  .https.onRequest(async (req, res) => {
    if (req.method !== "GET") {
      console.log("Invalid request!");
      res.status(400);
      return;
    }
	// await gtfs.import(config);
	// await gtfs.openDb(config);
	// const timetable_config = gtfs_timetable.setDefaultConfig(config);
  // const idk = await gtfs_timetable.getTimetablePages(timetable_config);
	// fs.writeFile('./timetable.json', JSON.stringify(idk), () => console.log('wrote'));
	// console.log(JSON.stringify(idk[0]));
  await generateDB();
    console.log("finished");
    res.send("finished");
  });
