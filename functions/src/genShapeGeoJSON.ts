import * as gtfs from "gtfs";

export class genShapeGeoJSON {
    //     Approach:
    // For each route,
    // 1 - Get the set of shapes corresponding to the route;
    // 2 - Select the longest shape (with the most coordinate pairs);
    // 3 - Draw a buffer around this longest shape;
    // 4 - For each remaining shape,
    // a - Remove points from the shape within the buffered area,
    // b - Add the remaining shape to the longest shape as an additional
    // LineString in the MultiLineString

    query: Object;
    fields: Array<string>;
    sortBy: Array<string>;

    constructor(q: Object={"route_id":["87-184","286-184","289-184"]}, f: Array<string> =[], s: Array<string> =[]) {
        this.query = q;
        this.fields = f;
        this.sortBy = s;
    }

    async getGeoJSON() {
        const db = await gtfs.openDb();
        let foo = await db.all(`
          SELECT r.route_id, r.route_short_name, r.route_long_name, 
          t.shape_id, s.shape_pt_lat, s.shape_pt_lon, s.shape_pt_sequence
          FROM routes r, trips t, shapes s
          WHERE r.route_id = t.route_id
          AND t.shape_id = s.shape_id
          AND r.route_id IN ('87-184','286-184','289-184');
        `);
        console.log(foo);
    }

    helloWorld() {
        console.log(this.query);
    }

}

const config = {
    sqlitePath: "./gtfs.db",
  };

gtfs
  .openDb(config)
  .then(() => {
    console.log("Database loaded");

    let geojson = new genShapeGeoJSON();
    geojson.helloWorld();
    geojson.getGeoJSON();
  })
  .catch((err: any) => {
    console.log("openDb error: " + err);
  });
