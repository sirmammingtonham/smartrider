import * as gtfs from "gtfs";

const config = {
  agencies: [
    {
      agency_key: "cdta",
      url: "https://www.cdta.org/schedules/google_transit.zip",
      exclude: []
    }
  ],
  sqlitePath: "./gtfs.db",
  csvOptions: {
    skip_lines_with_error: true
  },
  coordinatePrecision: 5,
  showMap: false
}

// needed to create the db file, shouldnt be used otherwise!
export function createDb() {
  gtfs.import(config).then(() => {
    gtfs.openDb(config).then(() => {
      gtfs.closeDb().then(() => {
        console.log("finished creating db");
      });
    });
  });
}

// basically if __name__ == "__main__":
if (typeof require !== 'undefined' && require.main === module) {
  createDb();
}