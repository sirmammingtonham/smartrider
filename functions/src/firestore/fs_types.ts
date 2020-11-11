/// firestore types
// think about grouping tables with the same id together
// merge calendar and calendar dates? other stuff with same id column?
export type Agency = {
//   agency_id: string;
  agency_name: string;
  agency_url: string;
  agency_timezone: string;
  agency_lang: string;
  agency_phone: string;
  agency_fare_url: string;
  agency_email: string;
};

export type Calendar = {
  service_id: string;
  // making it so we can just check the map instead of each row
  active_days: {
    [day: string]: boolean;
  };
  start_date: number;
  end_date: number;
};

export type CalendarDate = {
  service_id: string;
  date: number;
  exception_type: number;
};

export type Route = {
  // route_id: string,
  agency_id: string;
  route_short_name: string;
  route_long_name: string;
  route_desc: string;
  route_type: number;
  route_url: string;
  route_color: string;
  route_text_color: string;
  route_sort_order: string;
};

export type Shape = {
  shape_id: string;
  shape_pt_lat: number;
  shape_pt_lon: number;
  shape_pt_sequence: number;
//   shape_dist_traveled: number;
};

export type Stop = {
//   stop_id: string;
  stop_code: string;
  stop_name: string;
  stop_desc: string;
  stop_lat: number;
  stop_lon: number;
  zone_id: string;
  stop_url: string;
  location_type: number;
//   parent_station: string;
  stop_timezone: string;
  wheelchair_boarding: number;

  // fields not part of the specs, added to make life easier
  loc: number[]; // [<longitude>, <latitude>]
  routes: string[];
};

export type StopTime = {
  trip_id: string;
  arrival_time: string;
  departure_time: string;
  stop_id: string;
  stop_sequence: number;
//   stop_headsign: string;
  pickup_type: number;
  drop_off_type: number;
//   shape_dist_traveled: number;
  timepoint: number;
};

export type Trip = {
  route_id: string;
  service_id: string;
//   trip_id: string;
  trip_headsign: string;
  trip_short_name: string;
  direction_id: number;
  block_id: string;
  shape_id: string;
  wheelchair_accessible: number;
  bikes_allowed: number;
};

type timetable_stop = {
  stop_id: string;
  stop_name: string;
  service_id: string;
  stop_desc: string;
  stop_lat: number;
  stop_lon: number;
  stop_sequence: number;
  stop_times: string[];
};

export type Timetable = {
  route_id: string;
  stops: timetable_stop[];
};

// export type Polyline = {}
// just geojson
