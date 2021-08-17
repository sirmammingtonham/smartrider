import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'math_util.dart';

class SphericalUtils {
  // From https://pub.dev/packages/maps_toolkit.
  // Cloned this because the original lib is not compatible with google maps
  static const num earthRadius = 6371009.0;

  /// Returns the distance between two LatLngs, in meters.
  static num computeDistanceBetween(LatLng from, LatLng to) =>
      computeAngleBetween(from, to) * earthRadius;

  /// Returns distance on the unit sphere; the arguments are in radians.
  static num distanceRadians(num lat1, num lng1, num lat2, num lng2) =>
      MathUtil.arcHav(MathUtil.havDistance(lat1, lat2, lng1 - lng2));

  /// Returns the angle between two LatLngs, in radians. This is the same as the
  /// distance on the unit sphere.
  static num computeAngleBetween(LatLng from, LatLng to) => distanceRadians(
      MathUtil.toRadians(from.latitude),
      MathUtil.toRadians(from.longitude),
      MathUtil.toRadians(to.latitude),
      MathUtil.toRadians(to.longitude));

  /// Returns the heading from one LatLng to another LatLng. Headings are
  /// expressed in degrees clockwise from North within the range [-180,180).
  /// @return The heading in degrees clockwise from north.
  static num computeHeading(LatLng from, LatLng to) {
    // http://williams.best.vwh.net/avform.htm#Crs
    final fromLat = MathUtil.toRadians(from.latitude);
    final fromLng = MathUtil.toRadians(from.longitude);
    final toLat = MathUtil.toRadians(to.latitude);
    final toLng = MathUtil.toRadians(to.longitude);
    final dLng = toLng - fromLng;
    final heading = atan2(sin(dLng) * cos(toLat),
        cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLng));

    return MathUtil.wrap(MathUtil.toDegrees(heading), -180, 180);
  }

  /// Returns the LatLng resulting from moving a distance from an origin
  /// in the specified heading (expressed in degrees clockwise from north).
  /// @param from     The LatLng from which to start.
  /// @param distance The distance to travel.
  /// @param heading  The heading in degrees clockwise from north.
  static LatLng computeOffset(LatLng from, num distance, num heading) {
    distance /= earthRadius;
    heading = MathUtil.toRadians(heading);
    // http://williams.best.vwh.net/avform.htm#LL
    final fromLat = MathUtil.toRadians(from.latitude);
    final fromLng = MathUtil.toRadians(from.longitude);
    final cosDistance = cos(distance);
    final sinDistance = sin(distance);
    final sinFromLat = sin(fromLat);
    final cosFromLat = cos(fromLat);
    final sinLat =
        cosDistance * sinFromLat + sinDistance * cosFromLat * cos(heading);
    final dLng = atan2(sinDistance * cosFromLat * sin(heading),
        cosDistance - sinFromLat * sinLat);

    return LatLng(MathUtil.toDegrees(asin(sinLat)).toDouble(),
        MathUtil.toDegrees(fromLng + dLng).toDouble());
  }
}
