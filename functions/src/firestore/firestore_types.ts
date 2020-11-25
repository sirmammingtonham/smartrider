/// firestore types
// think about grouping tables with the same id together
// merge calendar and calendar dates? other stuff with same id column?
export interface Agency {
  agency_id: string;
  agency_name: string;
  agency_url: string;
  agency_timezone: string;
  agency_lang: string;
  agency_phone: string;
  agency_fare_url: string;
  agency_email: string;
};

export interface Calendar {
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

export interface Route {
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

export interface Shape {
  shape_id: string;
  shape_pt_lat: number;
  shape_pt_lon: number;
  shape_pt_sequence: number;
  shape_dist_traveled: number;
};

export interface Stop {
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

export interface Trip {
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

export interface Polyline {
  route_id: string;
  type: string;
  geoJSON: string; // convert to string so we can just pass it to request
};

export interface TimetableStop {
  // order: number;
  // trip_id: string;
  arrival_time: number;
  // departure_time: number;
  stop_id: string;
  formatted_time: string;

  stop_sequence: number;
  // stop_headsign: string;
  // pickup_type: number;
  // drop_off_type: number;
  // continuous_pickup: number;
  // continuous_drop_off: number;
  // timepoint: number;
  // type: string;
  interpolated: boolean;
  skipped: boolean;
}

export interface Timetable {
  route_id: string;
  direction_id: number;
  direction_name: string;
  label: string;
  start_date: string;
  end_date: string;
  // active_days: {
  //   [day: string]: boolean;
  // };
  service_id: string;
  include_dates: string[];
  exclude_dates: string[];
  stops: {
    stop_id: string;
    stop_name: string;
    stop_lat: number;
    stop_lon: number;
  }[];
  timetable: string[];
  // timetable: TimetableStop[];
}