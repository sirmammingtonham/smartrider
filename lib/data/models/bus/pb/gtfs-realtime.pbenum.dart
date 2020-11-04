///
//  Generated code. Do not modify.
//  source: gtfs-realtime.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class FeedHeader_Incrementality extends $pb.ProtobufEnum {
  static const FeedHeader_Incrementality FULL_DATASET = FeedHeader_Incrementality._(0, 'FULL_DATASET');
  static const FeedHeader_Incrementality DIFFERENTIAL = FeedHeader_Incrementality._(1, 'DIFFERENTIAL');

  static const $core.List<FeedHeader_Incrementality> values = <FeedHeader_Incrementality> [
    FULL_DATASET,
    DIFFERENTIAL,
  ];

  static final $core.Map<$core.int, FeedHeader_Incrementality> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FeedHeader_Incrementality valueOf($core.int value) => _byValue[value];

  const FeedHeader_Incrementality._($core.int v, $core.String n) : super(v, n);
}

class TripUpdate_StopTimeUpdate_ScheduleRelationship extends $pb.ProtobufEnum {
  static const TripUpdate_StopTimeUpdate_ScheduleRelationship SCHEDULED = TripUpdate_StopTimeUpdate_ScheduleRelationship._(0, 'SCHEDULED');
  static const TripUpdate_StopTimeUpdate_ScheduleRelationship SKIPPED = TripUpdate_StopTimeUpdate_ScheduleRelationship._(1, 'SKIPPED');
  static const TripUpdate_StopTimeUpdate_ScheduleRelationship NO_DATA = TripUpdate_StopTimeUpdate_ScheduleRelationship._(2, 'NO_DATA');

  static const $core.List<TripUpdate_StopTimeUpdate_ScheduleRelationship> values = <TripUpdate_StopTimeUpdate_ScheduleRelationship> [
    SCHEDULED,
    SKIPPED,
    NO_DATA,
  ];

  static final $core.Map<$core.int, TripUpdate_StopTimeUpdate_ScheduleRelationship> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TripUpdate_StopTimeUpdate_ScheduleRelationship valueOf($core.int value) => _byValue[value];

  const TripUpdate_StopTimeUpdate_ScheduleRelationship._($core.int v, $core.String n) : super(v, n);
}

class VehiclePosition_VehicleStopStatus extends $pb.ProtobufEnum {
  static const VehiclePosition_VehicleStopStatus INCOMING_AT = VehiclePosition_VehicleStopStatus._(0, 'INCOMING_AT');
  static const VehiclePosition_VehicleStopStatus STOPPED_AT = VehiclePosition_VehicleStopStatus._(1, 'STOPPED_AT');
  static const VehiclePosition_VehicleStopStatus IN_TRANSIT_TO = VehiclePosition_VehicleStopStatus._(2, 'IN_TRANSIT_TO');

  static const $core.List<VehiclePosition_VehicleStopStatus> values = <VehiclePosition_VehicleStopStatus> [
    INCOMING_AT,
    STOPPED_AT,
    IN_TRANSIT_TO,
  ];

  static final $core.Map<$core.int, VehiclePosition_VehicleStopStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VehiclePosition_VehicleStopStatus valueOf($core.int value) => _byValue[value];

  const VehiclePosition_VehicleStopStatus._($core.int v, $core.String n) : super(v, n);
}

class VehiclePosition_CongestionLevel extends $pb.ProtobufEnum {
  static const VehiclePosition_CongestionLevel UNKNOWN_CONGESTION_LEVEL = VehiclePosition_CongestionLevel._(0, 'UNKNOWN_CONGESTION_LEVEL');
  static const VehiclePosition_CongestionLevel RUNNING_SMOOTHLY = VehiclePosition_CongestionLevel._(1, 'RUNNING_SMOOTHLY');
  static const VehiclePosition_CongestionLevel STOP_AND_GO = VehiclePosition_CongestionLevel._(2, 'STOP_AND_GO');
  static const VehiclePosition_CongestionLevel CONGESTION = VehiclePosition_CongestionLevel._(3, 'CONGESTION');
  static const VehiclePosition_CongestionLevel SEVERE_CONGESTION = VehiclePosition_CongestionLevel._(4, 'SEVERE_CONGESTION');

  static const $core.List<VehiclePosition_CongestionLevel> values = <VehiclePosition_CongestionLevel> [
    UNKNOWN_CONGESTION_LEVEL,
    RUNNING_SMOOTHLY,
    STOP_AND_GO,
    CONGESTION,
    SEVERE_CONGESTION,
  ];

  static final $core.Map<$core.int, VehiclePosition_CongestionLevel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VehiclePosition_CongestionLevel valueOf($core.int value) => _byValue[value];

  const VehiclePosition_CongestionLevel._($core.int v, $core.String n) : super(v, n);
}

class VehiclePosition_OccupancyStatus extends $pb.ProtobufEnum {
  static const VehiclePosition_OccupancyStatus EMPTY = VehiclePosition_OccupancyStatus._(0, 'EMPTY');
  static const VehiclePosition_OccupancyStatus MANY_SEATS_AVAILABLE = VehiclePosition_OccupancyStatus._(1, 'MANY_SEATS_AVAILABLE');
  static const VehiclePosition_OccupancyStatus FEW_SEATS_AVAILABLE = VehiclePosition_OccupancyStatus._(2, 'FEW_SEATS_AVAILABLE');
  static const VehiclePosition_OccupancyStatus STANDING_ROOM_ONLY = VehiclePosition_OccupancyStatus._(3, 'STANDING_ROOM_ONLY');
  static const VehiclePosition_OccupancyStatus CRUSHED_STANDING_ROOM_ONLY = VehiclePosition_OccupancyStatus._(4, 'CRUSHED_STANDING_ROOM_ONLY');
  static const VehiclePosition_OccupancyStatus FULL = VehiclePosition_OccupancyStatus._(5, 'FULL');
  static const VehiclePosition_OccupancyStatus NOT_ACCEPTING_PASSENGERS = VehiclePosition_OccupancyStatus._(6, 'NOT_ACCEPTING_PASSENGERS');

  static const $core.List<VehiclePosition_OccupancyStatus> values = <VehiclePosition_OccupancyStatus> [
    EMPTY,
    MANY_SEATS_AVAILABLE,
    FEW_SEATS_AVAILABLE,
    STANDING_ROOM_ONLY,
    CRUSHED_STANDING_ROOM_ONLY,
    FULL,
    NOT_ACCEPTING_PASSENGERS,
  ];

  static final $core.Map<$core.int, VehiclePosition_OccupancyStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VehiclePosition_OccupancyStatus valueOf($core.int value) => _byValue[value];

  const VehiclePosition_OccupancyStatus._($core.int v, $core.String n) : super(v, n);
}

class Alert_Cause extends $pb.ProtobufEnum {
  static const Alert_Cause UNKNOWN_CAUSE = Alert_Cause._(1, 'UNKNOWN_CAUSE');
  static const Alert_Cause OTHER_CAUSE = Alert_Cause._(2, 'OTHER_CAUSE');
  static const Alert_Cause TECHNICAL_PROBLEM = Alert_Cause._(3, 'TECHNICAL_PROBLEM');
  static const Alert_Cause STRIKE = Alert_Cause._(4, 'STRIKE');
  static const Alert_Cause DEMONSTRATION = Alert_Cause._(5, 'DEMONSTRATION');
  static const Alert_Cause ACCIDENT = Alert_Cause._(6, 'ACCIDENT');
  static const Alert_Cause HOLIDAY = Alert_Cause._(7, 'HOLIDAY');
  static const Alert_Cause WEATHER = Alert_Cause._(8, 'WEATHER');
  static const Alert_Cause MAINTENANCE = Alert_Cause._(9, 'MAINTENANCE');
  static const Alert_Cause CONSTRUCTION = Alert_Cause._(10, 'CONSTRUCTION');
  static const Alert_Cause POLICE_ACTIVITY = Alert_Cause._(11, 'POLICE_ACTIVITY');
  static const Alert_Cause MEDICAL_EMERGENCY = Alert_Cause._(12, 'MEDICAL_EMERGENCY');

  static const $core.List<Alert_Cause> values = <Alert_Cause> [
    UNKNOWN_CAUSE,
    OTHER_CAUSE,
    TECHNICAL_PROBLEM,
    STRIKE,
    DEMONSTRATION,
    ACCIDENT,
    HOLIDAY,
    WEATHER,
    MAINTENANCE,
    CONSTRUCTION,
    POLICE_ACTIVITY,
    MEDICAL_EMERGENCY,
  ];

  static final $core.Map<$core.int, Alert_Cause> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Alert_Cause valueOf($core.int value) => _byValue[value];

  const Alert_Cause._($core.int v, $core.String n) : super(v, n);
}

class Alert_Effect extends $pb.ProtobufEnum {
  static const Alert_Effect NO_SERVICE = Alert_Effect._(1, 'NO_SERVICE');
  static const Alert_Effect REDUCED_SERVICE = Alert_Effect._(2, 'REDUCED_SERVICE');
  static const Alert_Effect SIGNIFICANT_DELAYS = Alert_Effect._(3, 'SIGNIFICANT_DELAYS');
  static const Alert_Effect DETOUR = Alert_Effect._(4, 'DETOUR');
  static const Alert_Effect ADDITIONAL_SERVICE = Alert_Effect._(5, 'ADDITIONAL_SERVICE');
  static const Alert_Effect MODIFIED_SERVICE = Alert_Effect._(6, 'MODIFIED_SERVICE');
  static const Alert_Effect OTHER_EFFECT = Alert_Effect._(7, 'OTHER_EFFECT');
  static const Alert_Effect UNKNOWN_EFFECT = Alert_Effect._(8, 'UNKNOWN_EFFECT');
  static const Alert_Effect STOP_MOVED = Alert_Effect._(9, 'STOP_MOVED');
  static const Alert_Effect NO_EFFECT = Alert_Effect._(10, 'NO_EFFECT');

  static const $core.List<Alert_Effect> values = <Alert_Effect> [
    NO_SERVICE,
    REDUCED_SERVICE,
    SIGNIFICANT_DELAYS,
    DETOUR,
    ADDITIONAL_SERVICE,
    MODIFIED_SERVICE,
    OTHER_EFFECT,
    UNKNOWN_EFFECT,
    STOP_MOVED,
    NO_EFFECT,
  ];

  static final $core.Map<$core.int, Alert_Effect> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Alert_Effect valueOf($core.int value) => _byValue[value];

  const Alert_Effect._($core.int v, $core.String n) : super(v, n);
}

class Alert_SeverityLevel extends $pb.ProtobufEnum {
  static const Alert_SeverityLevel UNKNOWN_SEVERITY = Alert_SeverityLevel._(1, 'UNKNOWN_SEVERITY');
  static const Alert_SeverityLevel INFO = Alert_SeverityLevel._(2, 'INFO');
  static const Alert_SeverityLevel WARNING = Alert_SeverityLevel._(3, 'WARNING');
  static const Alert_SeverityLevel SEVERE = Alert_SeverityLevel._(4, 'SEVERE');

  static const $core.List<Alert_SeverityLevel> values = <Alert_SeverityLevel> [
    UNKNOWN_SEVERITY,
    INFO,
    WARNING,
    SEVERE,
  ];

  static final $core.Map<$core.int, Alert_SeverityLevel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Alert_SeverityLevel valueOf($core.int value) => _byValue[value];

  const Alert_SeverityLevel._($core.int v, $core.String n) : super(v, n);
}

class TripDescriptor_ScheduleRelationship extends $pb.ProtobufEnum {
  static const TripDescriptor_ScheduleRelationship SCHEDULED = TripDescriptor_ScheduleRelationship._(0, 'SCHEDULED');
  static const TripDescriptor_ScheduleRelationship ADDED = TripDescriptor_ScheduleRelationship._(1, 'ADDED');
  static const TripDescriptor_ScheduleRelationship UNSCHEDULED = TripDescriptor_ScheduleRelationship._(2, 'UNSCHEDULED');
  static const TripDescriptor_ScheduleRelationship CANCELED = TripDescriptor_ScheduleRelationship._(3, 'CANCELED');
  static const TripDescriptor_ScheduleRelationship REPLACEMENT = TripDescriptor_ScheduleRelationship._(5, 'REPLACEMENT');

  static const $core.List<TripDescriptor_ScheduleRelationship> values = <TripDescriptor_ScheduleRelationship> [
    SCHEDULED,
    ADDED,
    UNSCHEDULED,
    CANCELED,
    REPLACEMENT,
  ];

  static final $core.Map<$core.int, TripDescriptor_ScheduleRelationship> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TripDescriptor_ScheduleRelationship valueOf($core.int value) => _byValue[value];

  const TripDescriptor_ScheduleRelationship._($core.int v, $core.String n) : super(v, n);
}

