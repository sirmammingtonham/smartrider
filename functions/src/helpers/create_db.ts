import * as gtfs from "gtfs";
import * as config from "../setup/gtfs_config.json";

// needed to create the db file, shouldnt be used otherwise!
export function createDb() {
  gtfs.import(config).then(() => {
    gtfs.openDb(config).then(() => {
      gtfs.closeDb().then(() => {
        console.log("finished");
      });
    });
  });
}