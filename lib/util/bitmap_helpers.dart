import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;

/// BitmapHelper:
/// Class containing functions that help us draw bitmaps
/// Currently only provides [getBitmapDescriptorFromSvgAsset]
/// 
/// Needed because the google maps flutter plugin sux
class BitmapHelper {
  /// Takes the path to an svg file [svgAssetLink] and optional [size]
  /// returns: a bitmap descriptor of the svg 
  static Future<BitmapDescriptor> getBitmapDescriptorFromSvgAsset(
      String svgAssetLink,
      {Size size}) async {
    final svgImage = await _getSvgImageFromAssets(svgAssetLink, size);
    // final sizedSvgImage = await _getSizedSvgImage(svgImage);

    final pngSizedBytes =
        await svgImage.toByteData(format: ui.ImageByteFormat.png);
    final unit8List = pngSizedBytes.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(unit8List);
  }

  static Future<ui.Image> _getSvgImageFromAssets(
      String svgAssetLink, Size targetSize) async {
    String svgString = await rootBundle.loadString(svgAssetLink);
    DrawableRoot drawableRoot = await svg.fromSvgString(svgString, null);

    // https://medium.com/@thinkdigitalsoftware/null-aware-operators-in-dart-53ffb8ae80bb
    final width = targetSize?.width ?? 50 * ui.window.devicePixelRatio;
    final height = targetSize?.height ?? 50 * ui.window.devicePixelRatio;


    ui.Picture picture = drawableRoot.toPicture(size: Size(width, height));

    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    return image;
  }
}
