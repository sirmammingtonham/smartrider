import * as admin from "firebase-admin";
import * as extract from "extract-zip";
import * as fs from "fs";
import * as path from "path";
import axios from "axios";
import * as parse from "csv-parse";
import { collection, add, set } from "typesaurus";
import { mapPromise } from "../helpers/async_util";
import * as models from "./fs_types";

const fsPromises = fs.promises;

admin.initializeApp({ projectId: "test" });
// const db = admin.firestore();

// const downloadDir = '/tmp/gfts';
const downloadDir = path.resolve("./gtfs");
const gtfsPath = `${downloadDir}/cdta-gtfs.zip`;

async function downloadFiles() {
  console.log(`Downloading GTFS from CDTA`);

  const response = await axios.get(
    "https://www.cdta.org/schedules/google_transit.zip",
    { responseType: "arraybuffer" }
  );
  if (response.status !== 200) {
    throw new Error("Couldn’t download files");
  }
  await fsPromises.writeFile(gtfsPath, response.data);
  console.log("File written successfully\n");
}

const getTextFiles = async (folderPath: any) => {
  const files = await fsPromises.readdir(folderPath);
  return files.reduce((array, filename) => {
    if (filename.slice(-3) === "txt") {
      array.push(path.join(downloadDir, filename));
    }
    return array;
  }, <string[]>[]);
};

const parseAgency = async (rows: string[][]) => {
  const agency = collection<models.Agency>("agency");
  return mapPromise(rows.slice(1), (row: string[]) => {
    return set(agency, row[0], {
      agency_name: row[1],
      agency_url: row[2],
      agency_timezone: row[3],
      agency_lang: row[4],
      agency_phone: row[5],
      agency_fare_url: row[6],
      agency_email: row[7],
    });
  });
};

const parseCalendar = async (rows: string[][]) => {
  const calendar = collection<models.Calendar>("calendar");
  return mapPromise(rows.slice(1), (row: string[]) => {
    return set(calendar, row[0], {
      service_id: row[0],
      active_days: {
        monday: row[1] == "1" ? true : false,
        tuesday: row[2] == "1" ? true : false,
        wednesday: row[3] == "1" ? true : false,
        thursday: row[4] == "1" ? true : false,
        friday: row[5] == "1" ? true : false,
        saturday: row[6] == "1" ? true : false,
        sunday: row[7] == "1" ? true : false,
      },
      start_date: +row[8],
      end_date: +row[9],
    });
  });
};

const parseCalendarDates = async (rows: string[][]) => {
  const calendar_dates = collection<models.CalendarDate>("calendarDates");
  return mapPromise(rows.slice(1), (row: string[]) => {
    return add(calendar_dates, {
      service_id: row[0],
      date: +row[1],
      exception_type: +row[2],
    });
  });
};

const parseRoutes = async (rows: string[][]) => {
  const routes = collection<models.Route>("routes");
  return mapPromise(rows.slice(1), (row: string[]) => {
    return set(routes, row[0], {
      agency_id: row[1],
      route_short_name: row[2],
      route_long_name: row[3],
      route_desc: row[4],
      route_type: +row[5],
      route_url: row[6],
      route_color: row[7],
      route_text_color: row[8],
      route_sort_order: row[9],
    });
  });
};

const parseShapes = async (rows: string[][]) => {
  const shapes = collection<models.Shape>("shapes");
  return mapPromise(
    rows.slice(1),
    (row: string[]) => {
      return add(shapes, {
        shape_id: row[0],
        shape_pt_lat: +row[1],
        shape_pt_lon: +row[2],
        shape_pt_sequence: +row[3],
      });
    },
    { concurrency: 5000 }
  );
};

const parseStops = async (rows: string[][]) => {
  const stops = collection<models.Stop>("stops");
  return mapPromise(
    rows.slice(1),
    (row: string[]) => {
      return set(stops, row[0], {
        stop_code: row[1],
        stop_name: row[2],
        stop_desc: row[3],
        stop_lat: +row[4],
        stop_lon: +row[5],
        zone_id: row[6],
        stop_url: row[7],
        location_type: +row[8],
        stop_timezone: row[9],
        wheelchair_boarding: +row[10],

        // fields not part of the specs, added to make life easier
        loc: [+row[4], +row[5]], // [<longitude>, <latitude>]
        routes: [],
      });
    },
    { concurrency: 5000 }
  );
};

const parseStopTimes = async (rows: string[][]) => {
  const stopTimes = collection<models.StopTime>("stopTimes");
  return mapPromise(
    rows.slice(1),
    (row: string[]) => {
      return add(stopTimes, {
        trip_id: row[0],
        arrival_time: row[1],
        departure_time: row[2],
        stop_id: row[3],
        stop_sequence: +row[4],
        pickup_type: +row[5],
        drop_off_type: +row[6],
        timepoint: +row[7],
      });
    },
    { concurrency: 5000 }
  );
};

const parseTrips = async (rows: string[][]) => {
  const trips = collection<models.Trip>("trips");
  return mapPromise(
    rows.slice(1),
    (row: string[]) => {
      return set(trips, row[2], {
        route_id: row[0],
        service_id: row[1],
        // trip_id: row[2],
        trip_headsign: row[3],
        trip_short_name: row[4],
        direction_id: +row[5],
        block_id: row[6],
        shape_id: row[7],
        wheelchair_accessible: +row[8],
        bikes_allowed: +row[9],
      });
    },
    { concurrency: 5000 }
  );
};

const parseCsv = async (name: string, rows: any) => {
  // there's probably a cleaner solution, but this is readable enough
  // and easy to understand
  // so dont @ me
  console.log(`started processing ${name}`);
  switch (name) {
    case "agency.txt":
      return parseAgency(rows);
    case "calendar.txt":
      return parseCalendar(rows);
    case "calendar_dates.txt":
      return parseCalendarDates(rows);
    case "error_warning.txt":
      return;
    case "fare_attributes.txt":
      return;
    case "fare_rules.txt":
      return;
    case "feed_info.txt":
      return;
    case "routes.txt":
      return parseRoutes(rows);
    case "shapes.txt":
      return parseShapes(rows);
    case "stops.txt":
      return parseStops(rows);
    case "stop_times.txt":
      return;
    // return parseStopTimes(rows); // too many adds!! should try to combine this into other collection
    case "trips.txt":
      return parseTrips(rows);
    default:
      console.warn(`Unaccounted for gtfs file! ${name}`);
      return;
  }
};

async function parseFiles() {
  await extract(gtfsPath, { dir: downloadDir });
  const files = await getTextFiles(downloadDir);

  for (const file of files) {
    let data = await fsPromises.readFile(file);
    parse(data, { columns: false, trim: true }, async (err, rows) => {
      if (err === undefined) {
        try {
          // regex to match filename exclusively (took a while to make this lol)
          // the exclamation at the end checks if the match is null before indexing
          const name = file.match(/(?:.(?<![/\\]))+$/gim)![0];

          console.time(name);
          await parseCsv(name, rows);
          console.timeEnd(name);
        } catch (error) {
          console.error(error);
        }
      } else {
        console.error(err);
      }
    });
  }
}

downloadFiles().then(() => {
  parseFiles().then(() => {
    console.log("done");
  });
});
