///
//  Generated code. Do not modify.
//  source: gtfs-realtime.proto
//

// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const FeedMessage$json = const {
  '1': 'FeedMessage',
  '2': const [
    const {'1': 'header', '3': 1, '4': 2, '5': 11, '6': '.transit_realtime.FeedHeader', '10': 'header'},
    const {'1': 'entity', '3': 2, '4': 3, '5': 11, '6': '.transit_realtime.FeedEntity', '10': 'entity'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const FeedHeader$json = const {
  '1': 'FeedHeader',
  '2': const [
    const {'1': 'gtfs_realtime_version', '3': 1, '4': 2, '5': 9, '10': 'gtfsRealtimeVersion'},
    const {'1': 'incrementality', '3': 2, '4': 1, '5': 14, '6': '.transit_realtime.FeedHeader.Incrementality', '7': 'FULL_DATASET', '10': 'incrementality'},
    const {'1': 'timestamp', '3': 3, '4': 1, '5': 4, '10': 'timestamp'},
  ],
  '4': const [FeedHeader_Incrementality$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const FeedHeader_Incrementality$json = const {
  '1': 'Incrementality',
  '2': const [
    const {'1': 'FULL_DATASET', '2': 0},
    const {'1': 'DIFFERENTIAL', '2': 1},
  ],
};

const FeedEntity$json = const {
  '1': 'FeedEntity',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    const {'1': 'is_deleted', '3': 2, '4': 1, '5': 8, '7': 'false', '10': 'isDeleted'},
    const {'1': 'trip_update', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.TripUpdate', '10': 'tripUpdate'},
    const {'1': 'vehicle', '3': 4, '4': 1, '5': 11, '6': '.transit_realtime.VehiclePosition', '10': 'vehicle'},
    const {'1': 'alert', '3': 5, '4': 1, '5': 11, '6': '.transit_realtime.Alert', '10': 'alert'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TripUpdate$json = const {
  '1': 'TripUpdate',
  '2': const [
    const {'1': 'trip', '3': 1, '4': 2, '5': 11, '6': '.transit_realtime.TripDescriptor', '10': 'trip'},
    const {'1': 'vehicle', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.VehicleDescriptor', '10': 'vehicle'},
    const {'1': 'stop_time_update', '3': 2, '4': 3, '5': 11, '6': '.transit_realtime.TripUpdate.StopTimeUpdate', '10': 'stopTimeUpdate'},
    const {'1': 'timestamp', '3': 4, '4': 1, '5': 4, '10': 'timestamp'},
    const {'1': 'delay', '3': 5, '4': 1, '5': 5, '10': 'delay'},
  ],
  '3': const [TripUpdate_StopTimeEvent$json, TripUpdate_StopTimeUpdate$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TripUpdate_StopTimeEvent$json = const {
  '1': 'StopTimeEvent',
  '2': const [
    const {'1': 'delay', '3': 1, '4': 1, '5': 5, '10': 'delay'},
    const {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'uncertainty', '3': 3, '4': 1, '5': 5, '10': 'uncertainty'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TripUpdate_StopTimeUpdate$json = const {
  '1': 'StopTimeUpdate',
  '2': const [
    const {'1': 'stop_sequence', '3': 1, '4': 1, '5': 13, '10': 'stopSequence'},
    const {'1': 'stop_id', '3': 4, '4': 1, '5': 9, '10': 'stopId'},
    const {'1': 'arrival', '3': 2, '4': 1, '5': 11, '6': '.transit_realtime.TripUpdate.StopTimeEvent', '10': 'arrival'},
    const {'1': 'departure', '3': 3, '4': 1, '5': 11, '6': '.transit_realtime.TripUpdate.StopTimeEvent', '10': 'departure'},
    const {'1': 'schedule_relationship', '3': 5, '4': 1, '5': 14, '6': '.transit_realtime.TripUpdate.StopTimeUpdate.ScheduleRelationship', '7': 'SCHEDULED', '10': 'scheduleRelationship'},
  ],
  '4': const [TripUpdate_StopTimeUpdate_ScheduleRelationship$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TripUpdate_StopTimeUpdate_ScheduleRelationship$json = const {
  '1': 'ScheduleRelationship',
  '2': const [
    const {'1': 'SCHEDULED', '2': 0},
    const {'1': 'SKIPPED', '2': 1},
    const {'1': 'NO_DATA', '2': 2},
  ],
};

const VehiclePosition$json = const {
  '1': 'VehiclePosition',
  '2': const [
    const {'1': 'trip', '3': 1, '4': 1, '5': 11, '6': '.transit_realtime.TripDescriptor', '10': 'trip'},
    const {'1': 'vehicle', '3': 8, '4': 1, '5': 11, '6': '.transit_realtime.VehicleDescriptor', '10': 'vehicle'},
    const {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.transit_realtime.Position', '10': 'position'},
    const {'1': 'current_stop_sequence', '3': 3, '4': 1, '5': 13, '10': 'currentStopSequence'},
    const {'1': 'stop_id', '3': 7, '4': 1, '5': 9, '10': 'stopId'},
    const {'1': 'current_status', '3': 4, '4': 1, '5': 14, '6': '.transit_realtime.VehiclePosition.VehicleStopStatus', '7': 'IN_TRANSIT_TO', '10': 'currentStatus'},
    const {'1': 'timestamp', '3': 5, '4': 1, '5': 4, '10': 'timestamp'},
    const {'1': 'congestion_level', '3': 6, '4': 1, '5': 14, '6': '.transit_realtime.VehiclePosition.CongestionLevel', '10': 'congestionLevel'},
    const {'1': 'occupancy_status', '3': 9, '4': 1, '5': 14, '6': '.transit_realtime.VehiclePosition.OccupancyStatus', '10': 'occupancyStatus'},
  ],
  '4': const [VehiclePosition_VehicleStopStatus$json, VehiclePosition_CongestionLevel$json, VehiclePosition_OccupancyStatus$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const VehiclePosition_VehicleStopStatus$json = const {
  '1': 'VehicleStopStatus',
  '2': const [
    const {'1': 'INCOMING_AT', '2': 0},
    const {'1': 'STOPPED_AT', '2': 1},
    const {'1': 'IN_TRANSIT_TO', '2': 2},
  ],
};

const VehiclePosition_CongestionLevel$json = const {
  '1': 'CongestionLevel',
  '2': const [
    const {'1': 'UNKNOWN_CONGESTION_LEVEL', '2': 0},
    const {'1': 'RUNNING_SMOOTHLY', '2': 1},
    const {'1': 'STOP_AND_GO', '2': 2},
    const {'1': 'CONGESTION', '2': 3},
    const {'1': 'SEVERE_CONGESTION', '2': 4},
  ],
};

const VehiclePosition_OccupancyStatus$json = const {
  '1': 'OccupancyStatus',
  '2': const [
    const {'1': 'EMPTY', '2': 0},
    const {'1': 'MANY_SEATS_AVAILABLE', '2': 1},
    const {'1': 'FEW_SEATS_AVAILABLE', '2': 2},
    const {'1': 'STANDING_ROOM_ONLY', '2': 3},
    const {'1': 'CRUSHED_STANDING_ROOM_ONLY', '2': 4},
    const {'1': 'FULL', '2': 5},
    const {'1': 'NOT_ACCEPTING_PASSENGERS', '2': 6},
  ],
};

const Alert$json = const {
  '1': 'Alert',
  '2': const [
    const {'1': 'active_period', '3': 1, '4': 3, '5': 11, '6': '.transit_realtime.TimeRange', '10': 'activePeriod'},
    const {'1': 'informed_entity', '3': 5, '4': 3, '5': 11, '6': '.transit_realtime.EntitySelector', '10': 'informedEntity'},
    const {'1': 'cause', '3': 6, '4': 1, '5': 14, '6': '.transit_realtime.Alert.Cause', '7': 'UNKNOWN_CAUSE', '10': 'cause'},
    const {'1': 'effect', '3': 7, '4': 1, '5': 14, '6': '.transit_realtime.Alert.Effect', '7': 'UNKNOWN_EFFECT', '10': 'effect'},
    const {'1': 'url', '3': 8, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'url'},
    const {'1': 'header_text', '3': 10, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'headerText'},
    const {'1': 'description_text', '3': 11, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'descriptionText'},
    const {'1': 'tts_header_text', '3': 12, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'ttsHeaderText'},
    const {'1': 'tts_description_text', '3': 13, '4': 1, '5': 11, '6': '.transit_realtime.TranslatedString', '10': 'ttsDescriptionText'},
    const {'1': 'severity_level', '3': 14, '4': 1, '5': 14, '6': '.transit_realtime.Alert.SeverityLevel', '7': 'UNKNOWN_SEVERITY', '10': 'severityLevel'},
  ],
  '4': const [Alert_Cause$json, Alert_Effect$json, Alert_SeverityLevel$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const Alert_Cause$json = const {
  '1': 'Cause',
  '2': const [
    const {'1': 'UNKNOWN_CAUSE', '2': 1},
    const {'1': 'OTHER_CAUSE', '2': 2},
    const {'1': 'TECHNICAL_PROBLEM', '2': 3},
    const {'1': 'STRIKE', '2': 4},
    const {'1': 'DEMONSTRATION', '2': 5},
    const {'1': 'ACCIDENT', '2': 6},
    const {'1': 'HOLIDAY', '2': 7},
    const {'1': 'WEATHER', '2': 8},
    const {'1': 'MAINTENANCE', '2': 9},
    const {'1': 'CONSTRUCTION', '2': 10},
    const {'1': 'POLICE_ACTIVITY', '2': 11},
    const {'1': 'MEDICAL_EMERGENCY', '2': 12},
  ],
};

const Alert_Effect$json = const {
  '1': 'Effect',
  '2': const [
    const {'1': 'NO_SERVICE', '2': 1},
    const {'1': 'REDUCED_SERVICE', '2': 2},
    const {'1': 'SIGNIFICANT_DELAYS', '2': 3},
    const {'1': 'DETOUR', '2': 4},
    const {'1': 'ADDITIONAL_SERVICE', '2': 5},
    const {'1': 'MODIFIED_SERVICE', '2': 6},
    const {'1': 'OTHER_EFFECT', '2': 7},
    const {'1': 'UNKNOWN_EFFECT', '2': 8},
    const {'1': 'STOP_MOVED', '2': 9},
    const {'1': 'NO_EFFECT', '2': 10},
  ],
};

const Alert_SeverityLevel$json = const {
  '1': 'SeverityLevel',
  '2': const [
    const {'1': 'UNKNOWN_SEVERITY', '2': 1},
    const {'1': 'INFO', '2': 2},
    const {'1': 'WARNING', '2': 3},
    const {'1': 'SEVERE', '2': 4},
  ],
};

const TimeRange$json = const {
  '1': 'TimeRange',
  '2': const [
    const {'1': 'start', '3': 1, '4': 1, '5': 4, '10': 'start'},
    const {'1': 'end', '3': 2, '4': 1, '5': 4, '10': 'end'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const Position$json = const {
  '1': 'Position',
  '2': const [
    const {'1': 'latitude', '3': 1, '4': 2, '5': 2, '10': 'latitude'},
    const {'1': 'longitude', '3': 2, '4': 2, '5': 2, '10': 'longitude'},
    const {'1': 'bearing', '3': 3, '4': 1, '5': 2, '10': 'bearing'},
    const {'1': 'odometer', '3': 4, '4': 1, '5': 1, '10': 'odometer'},
    const {'1': 'speed', '3': 5, '4': 1, '5': 2, '10': 'speed'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TripDescriptor$json = const {
  '1': 'TripDescriptor',
  '2': const [
    const {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    const {'1': 'route_id', '3': 5, '4': 1, '5': 9, '10': 'routeId'},
    const {'1': 'direction_id', '3': 6, '4': 1, '5': 13, '10': 'directionId'},
    const {'1': 'start_time', '3': 2, '4': 1, '5': 9, '10': 'startTime'},
    const {'1': 'start_date', '3': 3, '4': 1, '5': 9, '10': 'startDate'},
    const {'1': 'schedule_relationship', '3': 4, '4': 1, '5': 14, '6': '.transit_realtime.TripDescriptor.ScheduleRelationship', '10': 'scheduleRelationship'},
  ],
  '4': const [TripDescriptor_ScheduleRelationship$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TripDescriptor_ScheduleRelationship$json = const {
  '1': 'ScheduleRelationship',
  '2': const [
    const {'1': 'SCHEDULED', '2': 0},
    const {'1': 'ADDED', '2': 1},
    const {'1': 'UNSCHEDULED', '2': 2},
    const {'1': 'CANCELED', '2': 3},
    const {
      '1': 'REPLACEMENT',
      '2': 5,
      '3': const {'1': true},
    },
  ],
};

const VehicleDescriptor$json = const {
  '1': 'VehicleDescriptor',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'license_plate', '3': 3, '4': 1, '5': 9, '10': 'licensePlate'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const EntitySelector$json = const {
  '1': 'EntitySelector',
  '2': const [
    const {'1': 'agency_id', '3': 1, '4': 1, '5': 9, '10': 'agencyId'},
    const {'1': 'route_id', '3': 2, '4': 1, '5': 9, '10': 'routeId'},
    const {'1': 'route_type', '3': 3, '4': 1, '5': 5, '10': 'routeType'},
    const {'1': 'trip', '3': 4, '4': 1, '5': 11, '6': '.transit_realtime.TripDescriptor', '10': 'trip'},
    const {'1': 'stop_id', '3': 5, '4': 1, '5': 9, '10': 'stopId'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TranslatedString$json = const {
  '1': 'TranslatedString',
  '2': const [
    const {'1': 'translation', '3': 1, '4': 3, '5': 11, '6': '.transit_realtime.TranslatedString.Translation', '10': 'translation'},
  ],
  '3': const [TranslatedString_Translation$json],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

const TranslatedString_Translation$json = const {
  '1': 'Translation',
  '2': const [
    const {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
    const {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
  ],
  '5': const [
    const {'1': 1000, '2': 2000},
  ],
};

