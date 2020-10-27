import * as gtfs from "gtfs";
import * as turf from "@turf/turf";
// import * as gj from "geojson";
// import { Polygon } from "@turf/helpers";
// import { polygon } from "@turf/helpers";
// export {default as nearestPointToLine} from '@turf/nearest-point-to-line';
// export {default as pointToLineDistance} from '@turf/point-to-line-distance';

// function onlyUnique(value: any, index: any, self: any) {
//   return self.indexOf(value) === index;
// }


async function getGeoJSON() {
  // const db = await gtfs.openDb();
  // let raw = await db.all(`
  //   SELECT r.route_id, r.route_short_name, r.route_long_name, 
  //   t.shape_id, s.shape_pt_lat, s.shape_pt_lon, s.shape_pt_sequence
  //   FROM routes r, trips t, shapes s
  //   WHERE r.route_id = t.route_id
  //   AND t.shape_id = s.shape_id
  //   AND r.route_id IN ('87-184','286-184','289-184');
  // `);

  // let routes_trips_shapes = raw.reduce((unique: any, o: any) => {
  //   if(!unique.some((obj: any) => 
  //       obj.route_id === o.route_id && 
  //       obj.route_short_name === o.route_short_name &&
  //       obj.route_long_name === o.route_long_name &&
  //       obj.shape_id === o.shape_id &&
  //       obj.shape_pt_lat === o.shape_pt_lat &&
  //       obj.shape_pt_lon === o.shape_pt_lon &&
  //       obj.shape_pt_sequence === o.shape_pt_sequence
  //     )) {
  //     unique.push(o);
  //   }
  //   return unique;
  // },[]);
  let routes_trips_shapes = await gtfs.getShapesAsGeoJSON({ route_id: ["87-184"] });

  let longest_ct = 0;
  let longest: any;

  // Calculate longest shape in raw
  routes_trips_shapes.features.forEach((element: any) => {
    let current = element.geometry.coordinates.length;
    if (current > longest_ct) {
      longest = element;
    }

  });



  // const route_id = "87-184";

  let multiline = turf.lineString(longest.geometry.coordinates);
  console.log(JSON.stringify(multiline));
  // console.log(longest, route_id);



//   let area = turf.buffer(multiline, 0.0001, { units: "degrees" });

//   let multiline_polygon = turf.lineToPolygon(multiline);

//   let shorter_shape_ids = shape_ids.filter(i => i != longest);

//   shorter_shape_ids.forEach(shape_id => {
//     let this_shape = turf.lineString(getLatLon(routes_trips_shapes, shape_id));

//     // console.log(this_shape);
//     // console.log(area);

//     if (!turf.booleanWithin(this_shape, area)) {

//       let this_shape_polygon = turf.lineToPolygon(this_shape);
//       // console.log(turf.kinks(this_shape_polygon));

//       // console.log(JSON.stringify(area));

//       let new_part = turf.difference(area, this_shape_polygon) as turf.Feature<Polygon>;
//       // console.log(new_part);
//       multiline_polygon = turf.union(multiline_polygon, new_part) as turf.Feature<Polygon>;
//       area = turf.buffer(multiline, 0.0001);
//     }
//   });
//   console.log("finsihedddddd");
//   const options = { tolerance: 0.0005, highQuality: false };
//   let simplified_multiline = turf.cleanCoords(turf.simplify(multiline_polygon, options));

//   route_shapes.push(gj.Feature(simplified_multiline, { route_id: route_id }));
// });

// console.log(route_shapes);
}

const config = {
  sqlitePath: "./gtfs.db",
};

gtfs
  .openDb(config)
  .then(() => {
    console.log("[getGeoJSON] Database loaded");

    getGeoJSON()
      .then(() => {
        console.log("[getGeoJSON] Finished!");
      })
      .catch((err: any) => {
        console.log("[getGeoJSON] error: " + err);
      });

  })
  .catch((err: any) => {
    console.log("[getGeoJSON] openDb error: " + err);
  });
