import * as gtfs from "gtfs";
import * as turf from "@turf/turf";
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

const truncateCoordinate = (coordinate: Array<number>, precision: number) => {
  return [
    Math.round(coordinate[0] * 10 ** precision) / 10 ** precision,
    Math.round(coordinate[1] * 10 ** precision) / 10 ** precision,
  ];
};

const truncateGeoJSONDecimals = (geojson: any) => {
  for (const feature of geojson.features) {
    if (feature.geometry.coordinates) {
      if (feature.geometry.type.toLowerCase() === "point") {
        feature.geometry.coordinates = truncateCoordinate(
          feature.geometry.coordinates,
          5
        );
      } else if (feature.geometry.type.toLowerCase() === "linestring") {
        feature.geometry.coordinates = feature.geometry.coordinates.map(
          (coordinate: Array<number>) => truncateCoordinate(coordinate, 5)
        );
      }
    }
  }

  return geojson;
};

const simplifyGeoJSON = (geojson: any) => {
  try {
    const simplifiedGeojson = turf.simplify(geojson, {
      tolerance: 1 / 10 ** 5,
      highQuality: true,
    });

    return truncateGeoJSONDecimals(simplifiedGeojson);
  } catch {
    console.warn("Unable to simplify geojson");

    return truncateGeoJSONDecimals(geojson);
  }
};

export async function genShapeGeoJSON(query: any, fields: any, sortBy: any) {
  const routes = await gtfs.getRoutes(query, fields, sortBy);

  const raw_geojsons = Array();

  // gets and simplifies the geojson shape for all trips
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
          geojson.properties = { route_id: route.route_id };
          raw_geojsons.push(geojson);
        })
      );
    })
  );

  // group shapes by route_id
  const shapes_by_route = new Map();
  for (const geojson of raw_geojsons) {
    let obj: any;
    if ((obj = shapes_by_route.get(geojson.properties.route_id))) {
      obj.shapes.push(...geojson.features);
    } else {
      shapes_by_route.set(geojson.properties.route_id, {
        shapes: [...geojson.features],
      });
    }
  }

  // combine different shapes into single multiline string by route
  const output = Array();
  for (const [route_id, shape] of shapes_by_route) {
    const fc = turf.featureCollection(shape.shapes);
    const line = turf.combine(fc);
    if (line !== null) {
      line.properties = {
        route_id: route_id,
      };
      output.push(line);
    }
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

/// testing functions, leave out when deploying!
///
// const config = {
//   sqlitePath: "./gtfs.db",
// };

// gtfs
//   .openDb(config)
//   .then(() => {
//     console.log("[getGeoJSON] Database loaded");

//     genShapeGeoJSON({route_id: ["87-184","286-184","289-184"]}, [], [])
//       .then((output) => {
//         console.log("[getGeoJSON] Finished!");
//         console.log(JSON.stringify(output));
//       })
//       .catch((err: any) => {
//         console.log("[getGeoJSON] error: " + err);
//       });

//   })
//   .catch((err: any) => {
//     console.log("[getGeoJSON] openDb error: " + err);
//   });
