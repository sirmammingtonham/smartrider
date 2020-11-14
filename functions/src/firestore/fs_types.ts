/// firestore types
// think about grouping tables with the same id together
// merge calendar and calendar dates? other stuff with same id column?
export type Agency = {
  agency_id: string;
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
  exceptions: {
    [date: number]: number;
  };
};

export type Route = {
  route_id: string;
  agency_id: string;
  route_short_name: string;
  route_long_name: string;
  route_desc: string;
  route_type: number;
  route_url: string;
  route_color: string;
  route_text_color: string;
  route_sort_order: number;
  continuous_pickup: number;
  continuous_drop_off: number;

  // nonstandard, for convenience
  trip_ids: string[];
  shape_ids: string[];
  stop_ids: string[];
};

export type Shape = {
  shape_id: string;
  shape_pt_lat: number;
  shape_pt_lon: number;
  shape_pt_sequence: number;
  shape_dist_traveled: number;
};

export type Stop = {
  stop_id: string;
  stop_code: number;
  stop_name: string;
  stop_desc: string;
  stop_lat: number;
  stop_lon: number;
  zone_id: string;
  stop_url: string;
  location_type: number;
  parent_station: number;
  stop_timezone: string;
  wheelchair_boarding: number;
  leved_id: number;
  platform_code: string;

  // nonstandard, for convenience
  stop_sequence: number[];
  arrival_times: number[]; // in seconds since midnight
  departure_times: number[]; // in seconds since midnight

  route_ids: string[];
  shape_ids: string[];
  trip_ids: string[];
};

export type Trip = {
  trip_id: string;
  route_id: string;
  service_id: string;
  trip_headsign: string;
  trip_short_name: string;
  direction_id: number;
  block_id: string;
  shape_id: string;
  wheelchair_accessible: number;
  bikes_allowed: number;
};

export type Polyline = {
  route_id: string;
  type: string;
  geoJSON: string; // convert to string so we can just pass it to request
};

export type Timetable = {
  stop_id: string;
  stop_name: string;
  service_id: string;
  stop_lat: number;
  stop_lon: number;
  stop_sequence: number;
  stop_times: number[];
};
