import * as gtfs from "gtfs";
import * as turf from "@turf/turf";
import * as gj from "geojson";
export {default as nearestPointToLine} from '@turf/nearest-point-to-line';
export {default as pointToLineDistance} from '@turf/point-to-line-distance';

function onlyUnique(value: any, index: any, self: any) {
  return self.indexOf(value) === index;
}

function getLatLon(arr: any, shape: any) {
  // let shape_pt_lons = new Array;
  // let shape_pt_lats = new Array;
  let shape_pts = new Array;
  arr.forEach((element: any) => {
    if (element.shape_id == shape) {
      // shape_pt_lons.push(element.shape_pt_lon);
      // shape_pt_lats.push(element.shape_pt_lat);
      shape_pts.push([element.shape_pt_lon, element.shape_pt_lat]);
    }
  });
  // console.log(shape_pts);
  return shape_pts;
}

async function getGeoJSON() {
  const db = await gtfs.openDb();
  let raw = await db.all(`
    SELECT r.route_id, r.route_short_name, r.route_long_name, 
    t.shape_id, s.shape_pt_lat, s.shape_pt_lon, s.shape_pt_sequence
    FROM routes r, trips t, shapes s
    WHERE r.route_id = t.route_id
    AND t.shape_id = s.shape_id
    AND r.route_id IN ('87-184','286-184','289-184');
  `);

  let routes_trips_shapes = raw.reduce((unique: any, o: any) => {
    if(!unique.some((obj: any) => 
        obj.route_id === o.route_id && 
        obj.route_short_name === o.route_short_name &&
        obj.route_long_name === o.route_long_name &&
        obj.shape_id === o.shape_id &&
        obj.shape_pt_lat === o.shape_pt_lat &&
        obj.shape_pt_lon === o.shape_pt_lon &&
        obj.shape_pt_sequence === o.shape_pt_sequence
      )) {
      unique.push(o);
    }
    return unique;
  },[]);



  let route_shapes = new Array;

  let all_route_ids = new Array;
  routes_trips_shapes.forEach((element: any) => {
    all_route_ids.push(element.route_id);
  });
  let unique_route_ids = all_route_ids.filter(onlyUnique);
  

  unique_route_ids.forEach(route_id => {

    let shape_ids = new Array;

    routes_trips_shapes.forEach((element: any) => {
      if (element.route_id == route_id && !shape_ids.includes(element.shape_id)) {
        shape_ids.push(element.shape_id);
      }
    });

    let longest = shape_ids[0];
    let longest_pt_num = 0;

    routes_trips_shapes.forEach((element: any) => {
      if (element.shape_id == longest) {
        longest_pt_num += 1;
      }
    });

    shape_ids.forEach(shape_id => {
      let current_pt_num = 0;
      routes_trips_shapes.forEach((element: any) => {
        if (element.shape_id == longest) {
          current_pt_num += 1;
        }
      });

      if (current_pt_num > longest_pt_num) {
        longest = shape_id;
        longest_pt_num = current_pt_num;
      }
    });

    let multiline = turf.lineString(getLatLon(routes_trips_shapes, longest));

    let area = turf.buffer(multiline, 0.0001, {units: "degrees"});

    let shorter_shape_ids = shape_ids.filter(i => i != longest);

    shorter_shape_ids.forEach(shape_id => {
      let this_shape = turf.lineString(getLatLon(routes_trips_shapes, shape_id));
      
      console.log(this_shape);
      console.log(area);

      if (!turf.booleanWithin(this_shape, area)) {
        let this_shape_polygon = turf.lineToPolygon(this_shape);
        let new_part = turf.difference(area, this_shape_polygon);
        console.log(new_part);
        let multiline_polygon = turf.lineToPolygon(multiline);   
        let unioned_multiline = turf.union(multiline_polygon, new_part);
          area = turf.buffer(multiline, 0.0001);
      }
    });

    const tolerance = 0.00005;
    let simplified_multiline = turf.simplify(multiline, {tolerance: tolerance});

    route_shapes.push(gj.Feature(simplified_multiline, {route_id: route_id}));
  });

  console.log(route_shapes);
}

const config = {
    sqlitePath: "./gtfs.db",
  };

gtfs
  .openDb(config)
  .then(() => {
    console.log("Database loaded");

    getGeoJSON();

  })
  .catch((err: any) => {
    console.log("openDb error: " + err);
  });
