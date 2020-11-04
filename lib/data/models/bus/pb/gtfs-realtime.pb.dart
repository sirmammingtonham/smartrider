///
//  Generated code. Do not modify.
//  source: gtfs-realtime.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'gtfs-realtime.pbenum.dart';

export 'gtfs-realtime.pbenum.dart';

class FeedMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FeedMessage', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aQM<FeedHeader>(1, 'header', subBuilder: FeedHeader.create)
    ..pc<FeedEntity>(2, 'entity', $pb.PbFieldType.PM, subBuilder: FeedEntity.create)
    ..hasExtensions = true
  ;

  FeedMessage._() : super();
  factory FeedMessage() => create();
  factory FeedMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FeedMessage clone() => FeedMessage()..mergeFromMessage(this);
  FeedMessage copyWith(void Function(FeedMessage) updates) => super.copyWith((message) => updates(message as FeedMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FeedMessage create() => FeedMessage._();
  FeedMessage createEmptyInstance() => create();
  static $pb.PbList<FeedMessage> createRepeated() => $pb.PbList<FeedMessage>();
  @$core.pragma('dart2js:noInline')
  static FeedMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedMessage>(create);
  static FeedMessage _defaultInstance;

  @$pb.TagNumber(1)
  FeedHeader get header => $_getN(0);
  @$pb.TagNumber(1)
  set header(FeedHeader v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeader() => clearField(1);
  @$pb.TagNumber(1)
  FeedHeader ensureHeader() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<FeedEntity> get entity => $_getList(1);
}

class FeedHeader extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FeedHeader', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aQS(1, 'gtfsRealtimeVersion')
    ..e<FeedHeader_Incrementality>(2, 'incrementality', $pb.PbFieldType.OE, defaultOrMaker: FeedHeader_Incrementality.FULL_DATASET, valueOf: FeedHeader_Incrementality.valueOf, enumValues: FeedHeader_Incrementality.values)
    ..a<$fixnum.Int64>(3, 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasExtensions = true
  ;

  FeedHeader._() : super();
  factory FeedHeader() => create();
  factory FeedHeader.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedHeader.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FeedHeader clone() => FeedHeader()..mergeFromMessage(this);
  FeedHeader copyWith(void Function(FeedHeader) updates) => super.copyWith((message) => updates(message as FeedHeader));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FeedHeader create() => FeedHeader._();
  FeedHeader createEmptyInstance() => create();
  static $pb.PbList<FeedHeader> createRepeated() => $pb.PbList<FeedHeader>();
  @$core.pragma('dart2js:noInline')
  static FeedHeader getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedHeader>(create);
  static FeedHeader _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gtfsRealtimeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set gtfsRealtimeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGtfsRealtimeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearGtfsRealtimeVersion() => clearField(1);

  @$pb.TagNumber(2)
  FeedHeader_Incrementality get incrementality => $_getN(1);
  @$pb.TagNumber(2)
  set incrementality(FeedHeader_Incrementality v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasIncrementality() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncrementality() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
}

class FeedEntity extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FeedEntity', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aQS(1, 'id')
    ..aOB(2, 'isDeleted')
    ..aOM<TripUpdate>(3, 'tripUpdate', subBuilder: TripUpdate.create)
    ..aOM<VehiclePosition>(4, 'vehicle', subBuilder: VehiclePosition.create)
    ..aOM<Alert>(5, 'alert', subBuilder: Alert.create)
    ..hasExtensions = true
  ;

  FeedEntity._() : super();
  factory FeedEntity() => create();
  factory FeedEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FeedEntity clone() => FeedEntity()..mergeFromMessage(this);
  FeedEntity copyWith(void Function(FeedEntity) updates) => super.copyWith((message) => updates(message as FeedEntity));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FeedEntity create() => FeedEntity._();
  FeedEntity createEmptyInstance() => create();
  static $pb.PbList<FeedEntity> createRepeated() => $pb.PbList<FeedEntity>();
  @$core.pragma('dart2js:noInline')
  static FeedEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedEntity>(create);
  static FeedEntity _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isDeleted => $_getBF(1);
  @$pb.TagNumber(2)
  set isDeleted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsDeleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDeleted() => clearField(2);

  @$pb.TagNumber(3)
  TripUpdate get tripUpdate => $_getN(2);
  @$pb.TagNumber(3)
  set tripUpdate(TripUpdate v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTripUpdate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTripUpdate() => clearField(3);
  @$pb.TagNumber(3)
  TripUpdate ensureTripUpdate() => $_ensure(2);

  @$pb.TagNumber(4)
  VehiclePosition get vehicle => $_getN(3);
  @$pb.TagNumber(4)
  set vehicle(VehiclePosition v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasVehicle() => $_has(3);
  @$pb.TagNumber(4)
  void clearVehicle() => clearField(4);
  @$pb.TagNumber(4)
  VehiclePosition ensureVehicle() => $_ensure(3);

  @$pb.TagNumber(5)
  Alert get alert => $_getN(4);
  @$pb.TagNumber(5)
  set alert(Alert v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAlert() => $_has(4);
  @$pb.TagNumber(5)
  void clearAlert() => clearField(5);
  @$pb.TagNumber(5)
  Alert ensureAlert() => $_ensure(4);
}

class TripUpdate_StopTimeEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TripUpdate.StopTimeEvent', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..a<$core.int>(1, 'delay', $pb.PbFieldType.O3)
    ..aInt64(2, 'time')
    ..a<$core.int>(3, 'uncertainty', $pb.PbFieldType.O3)
    ..hasExtensions = true
  ;

  TripUpdate_StopTimeEvent._() : super();
  factory TripUpdate_StopTimeEvent() => create();
  factory TripUpdate_StopTimeEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripUpdate_StopTimeEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TripUpdate_StopTimeEvent clone() => TripUpdate_StopTimeEvent()..mergeFromMessage(this);
  TripUpdate_StopTimeEvent copyWith(void Function(TripUpdate_StopTimeEvent) updates) => super.copyWith((message) => updates(message as TripUpdate_StopTimeEvent));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeEvent create() => TripUpdate_StopTimeEvent._();
  TripUpdate_StopTimeEvent createEmptyInstance() => create();
  static $pb.PbList<TripUpdate_StopTimeEvent> createRepeated() => $pb.PbList<TripUpdate_StopTimeEvent>();
  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripUpdate_StopTimeEvent>(create);
  static TripUpdate_StopTimeEvent _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get delay => $_getIZ(0);
  @$pb.TagNumber(1)
  set delay($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDelay() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelay() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get uncertainty => $_getIZ(2);
  @$pb.TagNumber(3)
  set uncertainty($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUncertainty() => $_has(2);
  @$pb.TagNumber(3)
  void clearUncertainty() => clearField(3);
}

class TripUpdate_StopTimeUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TripUpdate.StopTimeUpdate', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..a<$core.int>(1, 'stopSequence', $pb.PbFieldType.OU3)
    ..aOM<TripUpdate_StopTimeEvent>(2, 'arrival', subBuilder: TripUpdate_StopTimeEvent.create)
    ..aOM<TripUpdate_StopTimeEvent>(3, 'departure', subBuilder: TripUpdate_StopTimeEvent.create)
    ..aOS(4, 'stopId')
    ..e<TripUpdate_StopTimeUpdate_ScheduleRelationship>(5, 'scheduleRelationship', $pb.PbFieldType.OE, defaultOrMaker: TripUpdate_StopTimeUpdate_ScheduleRelationship.SCHEDULED, valueOf: TripUpdate_StopTimeUpdate_ScheduleRelationship.valueOf, enumValues: TripUpdate_StopTimeUpdate_ScheduleRelationship.values)
    ..hasExtensions = true
  ;

  TripUpdate_StopTimeUpdate._() : super();
  factory TripUpdate_StopTimeUpdate() => create();
  factory TripUpdate_StopTimeUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripUpdate_StopTimeUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TripUpdate_StopTimeUpdate clone() => TripUpdate_StopTimeUpdate()..mergeFromMessage(this);
  TripUpdate_StopTimeUpdate copyWith(void Function(TripUpdate_StopTimeUpdate) updates) => super.copyWith((message) => updates(message as TripUpdate_StopTimeUpdate));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeUpdate create() => TripUpdate_StopTimeUpdate._();
  TripUpdate_StopTimeUpdate createEmptyInstance() => create();
  static $pb.PbList<TripUpdate_StopTimeUpdate> createRepeated() => $pb.PbList<TripUpdate_StopTimeUpdate>();
  @$core.pragma('dart2js:noInline')
  static TripUpdate_StopTimeUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripUpdate_StopTimeUpdate>(create);
  static TripUpdate_StopTimeUpdate _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get stopSequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set stopSequence($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStopSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearStopSequence() => clearField(1);

  @$pb.TagNumber(2)
  TripUpdate_StopTimeEvent get arrival => $_getN(1);
  @$pb.TagNumber(2)
  set arrival(TripUpdate_StopTimeEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasArrival() => $_has(1);
  @$pb.TagNumber(2)
  void clearArrival() => clearField(2);
  @$pb.TagNumber(2)
  TripUpdate_StopTimeEvent ensureArrival() => $_ensure(1);

  @$pb.TagNumber(3)
  TripUpdate_StopTimeEvent get departure => $_getN(2);
  @$pb.TagNumber(3)
  set departure(TripUpdate_StopTimeEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeparture() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeparture() => clearField(3);
  @$pb.TagNumber(3)
  TripUpdate_StopTimeEvent ensureDeparture() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get stopId => $_getSZ(3);
  @$pb.TagNumber(4)
  set stopId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStopId() => $_has(3);
  @$pb.TagNumber(4)
  void clearStopId() => clearField(4);

  @$pb.TagNumber(5)
  TripUpdate_StopTimeUpdate_ScheduleRelationship get scheduleRelationship => $_getN(4);
  @$pb.TagNumber(5)
  set scheduleRelationship(TripUpdate_StopTimeUpdate_ScheduleRelationship v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasScheduleRelationship() => $_has(4);
  @$pb.TagNumber(5)
  void clearScheduleRelationship() => clearField(5);
}

class TripUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TripUpdate', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aQM<TripDescriptor>(1, 'trip', subBuilder: TripDescriptor.create)
    ..pc<TripUpdate_StopTimeUpdate>(2, 'stopTimeUpdate', $pb.PbFieldType.PM, subBuilder: TripUpdate_StopTimeUpdate.create)
    ..aOM<VehicleDescriptor>(3, 'vehicle', subBuilder: VehicleDescriptor.create)
    ..a<$fixnum.Int64>(4, 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(5, 'delay', $pb.PbFieldType.O3)
    ..hasExtensions = true
  ;

  TripUpdate._() : super();
  factory TripUpdate() => create();
  factory TripUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TripUpdate clone() => TripUpdate()..mergeFromMessage(this);
  TripUpdate copyWith(void Function(TripUpdate) updates) => super.copyWith((message) => updates(message as TripUpdate));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TripUpdate create() => TripUpdate._();
  TripUpdate createEmptyInstance() => create();
  static $pb.PbList<TripUpdate> createRepeated() => $pb.PbList<TripUpdate>();
  @$core.pragma('dart2js:noInline')
  static TripUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripUpdate>(create);
  static TripUpdate _defaultInstance;

  @$pb.TagNumber(1)
  TripDescriptor get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(TripDescriptor v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => clearField(1);
  @$pb.TagNumber(1)
  TripDescriptor ensureTrip() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<TripUpdate_StopTimeUpdate> get stopTimeUpdate => $_getList(1);

  @$pb.TagNumber(3)
  VehicleDescriptor get vehicle => $_getN(2);
  @$pb.TagNumber(3)
  set vehicle(VehicleDescriptor v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVehicle() => $_has(2);
  @$pb.TagNumber(3)
  void clearVehicle() => clearField(3);
  @$pb.TagNumber(3)
  VehicleDescriptor ensureVehicle() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get delay => $_getIZ(4);
  @$pb.TagNumber(5)
  set delay($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDelay() => $_has(4);
  @$pb.TagNumber(5)
  void clearDelay() => clearField(5);
}

class VehiclePosition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('VehiclePosition', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aOM<TripDescriptor>(1, 'trip', subBuilder: TripDescriptor.create)
    ..aOM<Position>(2, 'position', subBuilder: Position.create)
    ..a<$core.int>(3, 'currentStopSequence', $pb.PbFieldType.OU3)
    ..e<VehiclePosition_VehicleStopStatus>(4, 'currentStatus', $pb.PbFieldType.OE, defaultOrMaker: VehiclePosition_VehicleStopStatus.IN_TRANSIT_TO, valueOf: VehiclePosition_VehicleStopStatus.valueOf, enumValues: VehiclePosition_VehicleStopStatus.values)
    ..a<$fixnum.Int64>(5, 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<VehiclePosition_CongestionLevel>(6, 'congestionLevel', $pb.PbFieldType.OE, defaultOrMaker: VehiclePosition_CongestionLevel.UNKNOWN_CONGESTION_LEVEL, valueOf: VehiclePosition_CongestionLevel.valueOf, enumValues: VehiclePosition_CongestionLevel.values)
    ..aOS(7, 'stopId')
    ..aOM<VehicleDescriptor>(8, 'vehicle', subBuilder: VehicleDescriptor.create)
    ..e<VehiclePosition_OccupancyStatus>(9, 'occupancyStatus', $pb.PbFieldType.OE, defaultOrMaker: VehiclePosition_OccupancyStatus.EMPTY, valueOf: VehiclePosition_OccupancyStatus.valueOf, enumValues: VehiclePosition_OccupancyStatus.values)
    ..hasExtensions = true
  ;

  VehiclePosition._() : super();
  factory VehiclePosition() => create();
  factory VehiclePosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VehiclePosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  VehiclePosition clone() => VehiclePosition()..mergeFromMessage(this);
  VehiclePosition copyWith(void Function(VehiclePosition) updates) => super.copyWith((message) => updates(message as VehiclePosition));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VehiclePosition create() => VehiclePosition._();
  VehiclePosition createEmptyInstance() => create();
  static $pb.PbList<VehiclePosition> createRepeated() => $pb.PbList<VehiclePosition>();
  @$core.pragma('dart2js:noInline')
  static VehiclePosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VehiclePosition>(create);
  static VehiclePosition _defaultInstance;

  @$pb.TagNumber(1)
  TripDescriptor get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(TripDescriptor v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => clearField(1);
  @$pb.TagNumber(1)
  TripDescriptor ensureTrip() => $_ensure(0);

  @$pb.TagNumber(2)
  Position get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(Position v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => clearField(2);
  @$pb.TagNumber(2)
  Position ensurePosition() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get currentStopSequence => $_getIZ(2);
  @$pb.TagNumber(3)
  set currentStopSequence($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentStopSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentStopSequence() => clearField(3);

  @$pb.TagNumber(4)
  VehiclePosition_VehicleStopStatus get currentStatus => $_getN(3);
  @$pb.TagNumber(4)
  set currentStatus(VehiclePosition_VehicleStopStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentStatus() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);

  @$pb.TagNumber(6)
  VehiclePosition_CongestionLevel get congestionLevel => $_getN(5);
  @$pb.TagNumber(6)
  set congestionLevel(VehiclePosition_CongestionLevel v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCongestionLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearCongestionLevel() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get stopId => $_getSZ(6);
  @$pb.TagNumber(7)
  set stopId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStopId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStopId() => clearField(7);

  @$pb.TagNumber(8)
  VehicleDescriptor get vehicle => $_getN(7);
  @$pb.TagNumber(8)
  set vehicle(VehicleDescriptor v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasVehicle() => $_has(7);
  @$pb.TagNumber(8)
  void clearVehicle() => clearField(8);
  @$pb.TagNumber(8)
  VehicleDescriptor ensureVehicle() => $_ensure(7);

  @$pb.TagNumber(9)
  VehiclePosition_OccupancyStatus get occupancyStatus => $_getN(8);
  @$pb.TagNumber(9)
  set occupancyStatus(VehiclePosition_OccupancyStatus v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasOccupancyStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearOccupancyStatus() => clearField(9);
}

class Alert extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Alert', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..pc<TimeRange>(1, 'activePeriod', $pb.PbFieldType.PM, subBuilder: TimeRange.create)
    ..pc<EntitySelector>(5, 'informedEntity', $pb.PbFieldType.PM, subBuilder: EntitySelector.create)
    ..e<Alert_Cause>(6, 'cause', $pb.PbFieldType.OE, defaultOrMaker: Alert_Cause.UNKNOWN_CAUSE, valueOf: Alert_Cause.valueOf, enumValues: Alert_Cause.values)
    ..e<Alert_Effect>(7, 'effect', $pb.PbFieldType.OE, defaultOrMaker: Alert_Effect.UNKNOWN_EFFECT, valueOf: Alert_Effect.valueOf, enumValues: Alert_Effect.values)
    ..aOM<TranslatedString>(8, 'url', subBuilder: TranslatedString.create)
    ..aOM<TranslatedString>(10, 'headerText', subBuilder: TranslatedString.create)
    ..aOM<TranslatedString>(11, 'descriptionText', subBuilder: TranslatedString.create)
    ..aOM<TranslatedString>(12, 'ttsHeaderText', subBuilder: TranslatedString.create)
    ..aOM<TranslatedString>(13, 'ttsDescriptionText', subBuilder: TranslatedString.create)
    ..e<Alert_SeverityLevel>(14, 'severityLevel', $pb.PbFieldType.OE, defaultOrMaker: Alert_SeverityLevel.UNKNOWN_SEVERITY, valueOf: Alert_SeverityLevel.valueOf, enumValues: Alert_SeverityLevel.values)
    ..hasExtensions = true
  ;

  Alert._() : super();
  factory Alert() => create();
  factory Alert.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Alert.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Alert clone() => Alert()..mergeFromMessage(this);
  Alert copyWith(void Function(Alert) updates) => super.copyWith((message) => updates(message as Alert));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Alert create() => Alert._();
  Alert createEmptyInstance() => create();
  static $pb.PbList<Alert> createRepeated() => $pb.PbList<Alert>();
  @$core.pragma('dart2js:noInline')
  static Alert getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alert>(create);
  static Alert _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TimeRange> get activePeriod => $_getList(0);

  @$pb.TagNumber(5)
  $core.List<EntitySelector> get informedEntity => $_getList(1);

  @$pb.TagNumber(6)
  Alert_Cause get cause => $_getN(2);
  @$pb.TagNumber(6)
  set cause(Alert_Cause v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCause() => $_has(2);
  @$pb.TagNumber(6)
  void clearCause() => clearField(6);

  @$pb.TagNumber(7)
  Alert_Effect get effect => $_getN(3);
  @$pb.TagNumber(7)
  set effect(Alert_Effect v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEffect() => $_has(3);
  @$pb.TagNumber(7)
  void clearEffect() => clearField(7);

  @$pb.TagNumber(8)
  TranslatedString get url => $_getN(4);
  @$pb.TagNumber(8)
  set url(TranslatedString v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(8)
  void clearUrl() => clearField(8);
  @$pb.TagNumber(8)
  TranslatedString ensureUrl() => $_ensure(4);

  @$pb.TagNumber(10)
  TranslatedString get headerText => $_getN(5);
  @$pb.TagNumber(10)
  set headerText(TranslatedString v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasHeaderText() => $_has(5);
  @$pb.TagNumber(10)
  void clearHeaderText() => clearField(10);
  @$pb.TagNumber(10)
  TranslatedString ensureHeaderText() => $_ensure(5);

  @$pb.TagNumber(11)
  TranslatedString get descriptionText => $_getN(6);
  @$pb.TagNumber(11)
  set descriptionText(TranslatedString v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDescriptionText() => $_has(6);
  @$pb.TagNumber(11)
  void clearDescriptionText() => clearField(11);
  @$pb.TagNumber(11)
  TranslatedString ensureDescriptionText() => $_ensure(6);

  @$pb.TagNumber(12)
  TranslatedString get ttsHeaderText => $_getN(7);
  @$pb.TagNumber(12)
  set ttsHeaderText(TranslatedString v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasTtsHeaderText() => $_has(7);
  @$pb.TagNumber(12)
  void clearTtsHeaderText() => clearField(12);
  @$pb.TagNumber(12)
  TranslatedString ensureTtsHeaderText() => $_ensure(7);

  @$pb.TagNumber(13)
  TranslatedString get ttsDescriptionText => $_getN(8);
  @$pb.TagNumber(13)
  set ttsDescriptionText(TranslatedString v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasTtsDescriptionText() => $_has(8);
  @$pb.TagNumber(13)
  void clearTtsDescriptionText() => clearField(13);
  @$pb.TagNumber(13)
  TranslatedString ensureTtsDescriptionText() => $_ensure(8);

  @$pb.TagNumber(14)
  Alert_SeverityLevel get severityLevel => $_getN(9);
  @$pb.TagNumber(14)
  set severityLevel(Alert_SeverityLevel v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasSeverityLevel() => $_has(9);
  @$pb.TagNumber(14)
  void clearSeverityLevel() => clearField(14);
}

class TimeRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TimeRange', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'start', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, 'end', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasExtensions = true
  ;

  TimeRange._() : super();
  factory TimeRange() => create();
  factory TimeRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TimeRange clone() => TimeRange()..mergeFromMessage(this);
  TimeRange copyWith(void Function(TimeRange) updates) => super.copyWith((message) => updates(message as TimeRange));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimeRange create() => TimeRange._();
  TimeRange createEmptyInstance() => create();
  static $pb.PbList<TimeRange> createRepeated() => $pb.PbList<TimeRange>();
  @$core.pragma('dart2js:noInline')
  static TimeRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeRange>(create);
  static TimeRange _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);
}

class Position extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Position', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..a<$core.double>(1, 'latitude', $pb.PbFieldType.QF)
    ..a<$core.double>(2, 'longitude', $pb.PbFieldType.QF)
    ..a<$core.double>(3, 'bearing', $pb.PbFieldType.OF)
    ..a<$core.double>(4, 'odometer', $pb.PbFieldType.OD)
    ..a<$core.double>(5, 'speed', $pb.PbFieldType.OF)
    ..hasExtensions = true
  ;

  Position._() : super();
  factory Position() => create();
  factory Position.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Position.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Position clone() => Position()..mergeFromMessage(this);
  Position copyWith(void Function(Position) updates) => super.copyWith((message) => updates(message as Position));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get bearing => $_getN(2);
  @$pb.TagNumber(3)
  set bearing($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBearing() => $_has(2);
  @$pb.TagNumber(3)
  void clearBearing() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get odometer => $_getN(3);
  @$pb.TagNumber(4)
  set odometer($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOdometer() => $_has(3);
  @$pb.TagNumber(4)
  void clearOdometer() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get speed => $_getN(4);
  @$pb.TagNumber(5)
  set speed($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSpeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpeed() => clearField(5);
}

class TripDescriptor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TripDescriptor', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aOS(1, 'tripId')
    ..aOS(2, 'startTime')
    ..aOS(3, 'startDate')
    ..e<TripDescriptor_ScheduleRelationship>(4, 'scheduleRelationship', $pb.PbFieldType.OE, defaultOrMaker: TripDescriptor_ScheduleRelationship.SCHEDULED, valueOf: TripDescriptor_ScheduleRelationship.valueOf, enumValues: TripDescriptor_ScheduleRelationship.values)
    ..aOS(5, 'routeId')
    ..a<$core.int>(6, 'directionId', $pb.PbFieldType.OU3)
    ..hasExtensions = true
  ;

  TripDescriptor._() : super();
  factory TripDescriptor() => create();
  factory TripDescriptor.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TripDescriptor.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TripDescriptor clone() => TripDescriptor()..mergeFromMessage(this);
  TripDescriptor copyWith(void Function(TripDescriptor) updates) => super.copyWith((message) => updates(message as TripDescriptor));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TripDescriptor create() => TripDescriptor._();
  TripDescriptor createEmptyInstance() => create();
  static $pb.PbList<TripDescriptor> createRepeated() => $pb.PbList<TripDescriptor>();
  @$core.pragma('dart2js:noInline')
  static TripDescriptor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TripDescriptor>(create);
  static TripDescriptor _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get startTime => $_getSZ(1);
  @$pb.TagNumber(2)
  set startTime($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get startDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set startDate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartDate() => clearField(3);

  @$pb.TagNumber(4)
  TripDescriptor_ScheduleRelationship get scheduleRelationship => $_getN(3);
  @$pb.TagNumber(4)
  set scheduleRelationship(TripDescriptor_ScheduleRelationship v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasScheduleRelationship() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheduleRelationship() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get routeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set routeId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRouteId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRouteId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get directionId => $_getIZ(5);
  @$pb.TagNumber(6)
  set directionId($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDirectionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearDirectionId() => clearField(6);
}

class VehicleDescriptor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('VehicleDescriptor', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aOS(1, 'id')
    ..aOS(2, 'label')
    ..aOS(3, 'licensePlate')
    ..hasExtensions = true
  ;

  VehicleDescriptor._() : super();
  factory VehicleDescriptor() => create();
  factory VehicleDescriptor.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VehicleDescriptor.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  VehicleDescriptor clone() => VehicleDescriptor()..mergeFromMessage(this);
  VehicleDescriptor copyWith(void Function(VehicleDescriptor) updates) => super.copyWith((message) => updates(message as VehicleDescriptor));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VehicleDescriptor create() => VehicleDescriptor._();
  VehicleDescriptor createEmptyInstance() => create();
  static $pb.PbList<VehicleDescriptor> createRepeated() => $pb.PbList<VehicleDescriptor>();
  @$core.pragma('dart2js:noInline')
  static VehicleDescriptor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VehicleDescriptor>(create);
  static VehicleDescriptor _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get licensePlate => $_getSZ(2);
  @$pb.TagNumber(3)
  set licensePlate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLicensePlate() => $_has(2);
  @$pb.TagNumber(3)
  void clearLicensePlate() => clearField(3);
}

class EntitySelector extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EntitySelector', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aOS(1, 'agencyId')
    ..aOS(2, 'routeId')
    ..a<$core.int>(3, 'routeType', $pb.PbFieldType.O3)
    ..aOM<TripDescriptor>(4, 'trip', subBuilder: TripDescriptor.create)
    ..aOS(5, 'stopId')
    ..hasExtensions = true
  ;

  EntitySelector._() : super();
  factory EntitySelector() => create();
  factory EntitySelector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntitySelector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  EntitySelector clone() => EntitySelector()..mergeFromMessage(this);
  EntitySelector copyWith(void Function(EntitySelector) updates) => super.copyWith((message) => updates(message as EntitySelector));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EntitySelector create() => EntitySelector._();
  EntitySelector createEmptyInstance() => create();
  static $pb.PbList<EntitySelector> createRepeated() => $pb.PbList<EntitySelector>();
  @$core.pragma('dart2js:noInline')
  static EntitySelector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntitySelector>(create);
  static EntitySelector _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get agencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set agencyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAgencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgencyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get routeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set routeId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRouteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRouteId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get routeType => $_getIZ(2);
  @$pb.TagNumber(3)
  set routeType($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRouteType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRouteType() => clearField(3);

  @$pb.TagNumber(4)
  TripDescriptor get trip => $_getN(3);
  @$pb.TagNumber(4)
  set trip(TripDescriptor v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTrip() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrip() => clearField(4);
  @$pb.TagNumber(4)
  TripDescriptor ensureTrip() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get stopId => $_getSZ(4);
  @$pb.TagNumber(5)
  set stopId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStopId() => $_has(4);
  @$pb.TagNumber(5)
  void clearStopId() => clearField(5);
}

class TranslatedString_Translation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TranslatedString.Translation', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..aQS(1, 'text')
    ..aOS(2, 'language')
    ..hasExtensions = true
  ;

  TranslatedString_Translation._() : super();
  factory TranslatedString_Translation() => create();
  factory TranslatedString_Translation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranslatedString_Translation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TranslatedString_Translation clone() => TranslatedString_Translation()..mergeFromMessage(this);
  TranslatedString_Translation copyWith(void Function(TranslatedString_Translation) updates) => super.copyWith((message) => updates(message as TranslatedString_Translation));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranslatedString_Translation create() => TranslatedString_Translation._();
  TranslatedString_Translation createEmptyInstance() => create();
  static $pb.PbList<TranslatedString_Translation> createRepeated() => $pb.PbList<TranslatedString_Translation>();
  @$core.pragma('dart2js:noInline')
  static TranslatedString_Translation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranslatedString_Translation>(create);
  static TranslatedString_Translation _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => clearField(2);
}

class TranslatedString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TranslatedString', package: const $pb.PackageName('transit_realtime'), createEmptyInstance: create)
    ..pc<TranslatedString_Translation>(1, 'translation', $pb.PbFieldType.PM, subBuilder: TranslatedString_Translation.create)
    ..hasExtensions = true
  ;

  TranslatedString._() : super();
  factory TranslatedString() => create();
  factory TranslatedString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TranslatedString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TranslatedString clone() => TranslatedString()..mergeFromMessage(this);
  TranslatedString copyWith(void Function(TranslatedString) updates) => super.copyWith((message) => updates(message as TranslatedString));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TranslatedString create() => TranslatedString._();
  TranslatedString createEmptyInstance() => create();
  static $pb.PbList<TranslatedString> createRepeated() => $pb.PbList<TranslatedString>();
  @$core.pragma('dart2js:noInline')
  static TranslatedString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranslatedString>(create);
  static TranslatedString _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TranslatedString_Translation> get translation => $_getList(0);
}

