import { genShapeGeoJSON } from "../helpers/bus_util";
import * as gtfs from "gtfs";
import * as config from "../setup/gtfs_config.json";
import * as turf from "@turf/turf";
import * as fs from "fs";

const test = async () => {
  await gtfs.openDb(config);
  const polylines = await genShapeGeoJSON(
    // { route_id: ["87-185", "286-185", "289-185"] },
    { route_id: ["286-185", "289-185"] },
    [],
    []
  );
//   const buffer = turf.buffer(polylines[1], 4, {units: 'meters'});
const bruh = [];
for (const line of polylines) {
    for (const line2 of polylines) {
        if (line === line2) {
            continue;
        }
        bruh.push(...turf.lineOverlap(line, line2, {tolerance: 0.007}).features);
    }
}
  fs.writeFileSync(
    "out.geojson",
    // JSON.stringify(turf.lineOverlap(polylines[0], polylines[1], {tolerance: 0.007}))
    JSON.stringify(turf.featureCollection(bruh))
    // JSON.stringify(polylines[0])
  );
  // console.log(polylines);
};

test()
  .then(() => {
    console.log("done");
  })
  .catch((err) => {
    console.log(err);
  });
