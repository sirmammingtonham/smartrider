import * as gtfs from "gtfs";
import * as turf from "@turf/turf";
import * as dissolve from "geojson-dissolve";
import { uniqBy } from "lodash";

const fetchGeoJSON = async (routeId: string, directionId: string) => {
  const query: any = {};

  if (routeId !== undefined && directionId !== undefined) {
    query.route_id = routeId;
    query.direction_id = directionId;
  }

  const shapesGeojson = await gtfs.getShapesAsGeoJSON(query);

  return shapesGeojson;
};

const simplifyGeoJSON = (geojson: any) => {
  try {
    const simplifiedGeojson = turf.simplify(geojson, {
      tolerance: 1 / 10 ** 5,
      highQuality: true,
    });

    return simplifiedGeojson;
  } catch {
    console.warn("Unable to simplify geojson");

    return geojson;
  }
};

export async function genShapeGeoJSON(query: any, fields: any, sortBy: any) {
  const routes = await gtfs.getRoutes(query, fields, sortBy);
  console.log(routes);
  const shapes_by_route = new Map();

  // gets and simplifies the geojson shape for all trips
  // adds them to map that separates shapes by route
  await Promise.all(
    routes.map(async (route: any) => {
      const trips = await gtfs.getTrips(
        {
          route_id: route.route_id,
        },
        ["trip_headsign", "direction_id"]
      );
      const directions = uniqBy(trips, (trip: any) => trip.trip_headsign);
      await Promise.all(
        directions.map(async (direction: any) => {
          const geojson = simplifyGeoJSON(
            await fetchGeoJSON(route.route_id, direction.direction_id)
          );

          let obj: any;
          if ((obj = shapes_by_route.get(route.route_id))) {
            obj.shapes.push(...geojson.features);
          } else {
            shapes_by_route.set(route.route_id, {
              shapes: [...geojson.features]
            });
          }
        }));
    })
  );


  // combine different shapes into single multiline string by route
  const output = Array();
  let combined:any;
  for (const [route_id, shapes] of shapes_by_route) {
    combined = dissolve(shapes.shapes);
    combined.properties = {route_id: route_id};
    output.push(combined);
  }

  return output;
}

export async function genBusTimetable(query: any) {
  const db = await gtfs.getDb();

  const query_res = await db.all(`
  SELECT r.route_id, r.route_short_name, r.route_long_name, s.stop_name, s.stop_id, 
    s.stop_lat, s.stop_lon, st.arrival_time, st.stop_sequence, c.service_id
  FROM routes r, trips t, stop_times st, stops s, calendar c
  WHERE r.route_id = t.route_id
  AND c.${query.days}
  AND c.service_id = t.service_id
  AND t.trip_id = st.trip_id
  AND st.stop_id = s.stop_id
  AND r.route_id IN ${query.route_ids}
  ORDER BY r.route_id, s.stop_id, st.arrival_time;`);

  const stop_map = new Map();
  query_res.forEach((row: any) => {
    let obj; // stores stop info in the stop_map
    if ((obj = stop_map.get(row.stop_id))) {
      obj.stop_times.push(row.arrival_time);
    } else {
      stop_map.set(row.stop_id, {
        route_id: row.route_id,
        stop_name: row.stop_name,
        service_id: row.service_id,
        stop_lat: row.stop_lat,
        stop_lon: row.stop_lon,
        stop_sequence: row.stop_sequence,
        stop_times: [row.arrival_time],
      });
    }
  });

  const route_map: any = new Object();
  stop_map.forEach((value, _) => {
    let obj; // stores stop info in the stop_map
    if ((obj = route_map[value.route_id])) {
      obj.stops.push(value);
    } else {
      route_map[value.route_id] = {
        stops: [value],
      };
    }
  });

  return route_map;
}

function reformatRouteLineStrings(input: any) {
  let routeLineString;
  // If routeLineString is not homogenous, convert to multiline
  if (input.type === "LineString") {
    routeLineString = turf.combine(turf.featureCollection([turf.lineString(input.coordinates)])).features[0].geometry;
    routeLineString.properties = input.properties; 
    // console.log(JSON.stringify(routeLineString));
  }
  else {
    // console.log("multiline");
    // console.log(JSON.stringify(routeLineString));
    routeLineString = input;
  }

  return routeLineString;
}

export async function fixPolylineOffset(raw: any) {
  // console.log(JSON.stringify(raw));
  let output:any = [];

  for (let rawRouteLineString of raw) {
    // If routeLineString is not homogenous, convert to multiline
    let routeLineString = reformatRouteLineStrings(rawRouteLineString);
    // console.log(JSON.stringify(routeLineString));
    let newCoords:any = [];

    routeLineString.coordinates.forEach((lineString: any) => {
      let line1 = lineString.shift();
      let line2 = lineString[0];
      let newLineString = turf.lineString([line1, line2]).geometry;
      // console.log(turf.lineString([line1, line2]).geometry);

      for (let index in lineString) {
        // separate each lineString into independent lines
        if (+index != lineString.length - 1) {
          const currentLine = turf.lineString([lineString[+index], lineString[+index + 1]]);
          let isOffset = false;
          // console.log(JSON.stringify(currentLine));

          // create buffer for current line
          const buffer = turf.buffer(currentLine, 2, {units: 'meters'});
          // console.log(JSON.stringify(buffer));

          // Check if other routes cross buffer
          for (let compRawRouteLineString of raw) {
            let compRouteLineString = reformatRouteLineStrings(compRawRouteLineString);
            // Make sure route_ids don't match
            if (compRouteLineString.properties.route_id != routeLineString.properties.route_id) {
              // console.log(compRouteLineString.properties.route_id + " " + routeLineString.properties.route_id)
              const compFC = turf.flatten(compRouteLineString);
              for (let compLineString of compFC.features) {
                if (turf.booleanCrosses(buffer, compLineString)) {
                  // console.log(JSON.stringify(turf.combine(turf.featureCollection([buffer, compLineString]))));
                  const offset = turf.lineOffset(currentLine, 2, {units: "meters"});
                  isOffset = true;
                  // console.log(JSON.stringify(turf.combine(turf.featureCollection([currentLine, offset]))));
                  newLineString = dissolve(newLineString, offset);
                }
                
              }
            }
          }

          if (isOffset == false) {
            newLineString = dissolve(newLineString, currentLine);
          }
        }
      }
      // console.log(JSON.stringify(newLineString));
      if (newLineString?.type == "LineString") {
        // console.log(JSON.stringify(newLineString));
        newCoords.push(newLineString?.coordinates);
      }
      else if (newLineString?.type == "MultiLineString") {
        // console.log(JSON.stringify(newLineString));
        newLineString.coordinates.forEach(ls => {
          newCoords.push(ls);
        });
      }
    });
    // console.log(newCoords);
    let multi:any = turf.multiLineString(newCoords).geometry;
    multi.properties = {"route_id": routeLineString.properties.route_id };
    // console.log(JSON.stringify(newMultiLine)); 
    output.push(multi);
  }
  console.log(JSON.stringify(output[0]));
  return output;
}


// const config = {
//   sqlitePath: "./gtfs.db",
// };

// gtfs
//   .openDb(config)
//   .then(() => {
//     console.log("[getGeoJSON] Database loaded");
//     // {route_id: ["87-184","286-184","289-184"]}
//     genShapeGeoJSON({ route_id: ["87-184","286-184","289-184"]}, [], []).then((output) => {
//       console.log("[getGeoJSON] Finished!");
//       console.log(fixPolylineOffset(output));
//     });
//   })
//   .catch((err: any) => {
//     console.log("[getGeoJSON] openDb error: " + err);
//   });
