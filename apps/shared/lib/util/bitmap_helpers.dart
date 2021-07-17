import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Color extension:
/// Allows us to convert colors to hex string
extension ColorExtended on Color {
  /// Prefixes a hash sign if [leadingHashSign]
  /// is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Darkens this color by [amount]
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// Lightens this color by [amount]
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

/// BitmapHelper:
/// Class containing functions that help us draw bitmaps
/// Currently only provides [getBitmapDescriptorFromSvgAsset]
///
/// Needed because the google maps flutter plugin sux
class BitmapHelper {
  /// Takes the path to an svg file [svgAssetLink]
  ///and optional [color] and [size]
  /// returns: a bitmap descriptor of the svg
  static Future<BitmapDescriptor> getBitmapDescriptorFromSvgAsset(
      String svgAssetLink,
      {Color? color,
      Size? size}) async {
    final svgImage = await _getSvgImageFromAssets(svgAssetLink, color, size);
    // final sizedSvgImage = await _getSizedSvgImage(svgImage);

    final pngSizedBytes =
        await (svgImage.toByteData(format: ui.ImageByteFormat.png));
    if (pngSizedBytes != null) {
      final unit8List = pngSizedBytes.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(unit8List);
    }
    return BitmapDescriptor.defaultMarker;
  }

  static Future<ui.Image> _getSvgImageFromAssets(
      String svgAssetLink, Color? color, Size? targetSize) async {
    var svgString = await rootBundle.loadString(svgAssetLink);

    if (color != null) {
      svgString =
          svgString.replaceAll('fill="#fff"', 'fill="${color.toHex()}"');
    }

    final drawableRoot = await svg.fromSvgString(svgString, svgString);

    final width = targetSize?.width ?? 50 * ui.window.devicePixelRatio;
    final height = targetSize?.height ?? 50 * ui.window.devicePixelRatio;

    final picture = drawableRoot.toPicture(size: Size(width, height));

    final image = await picture.toImage(width.toInt(), height.toInt());
    return image;
  }
}
