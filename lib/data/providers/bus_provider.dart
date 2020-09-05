import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';

import '../models/bus/bus_advisory.dart';
import '../models/bus/bus_gtfs.dart';
import '../models/bus/bus_updates.dart';
import '../models/bus/bus_vehicles.dart';

class BusProvider {
  Future fetch() async {
    var dio = Dio();
    var url = 'https://www.cdta.org/schedules/google_transit.zip';

    await downloadZip(dio, url);
    await unzip();
  }

  Future downloadZip(Dio dio, String url) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      Response response = await dio.download(url, '${directory.path}/gtfs.zip');
      print("Downloaded gtfs data...");
    } catch (e) {
      print(e);
    }
  }

  Future unzip() async {
    final directory = await getApplicationDocumentsDirectory();
    final zipFile = File('${directory.path}/gtfs.zip');
    final destinationDir = Directory('${directory.path}');
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: (zipEntry, progress) {
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ExtractOperation.extract;
          });
    } catch (e) {
      print(e);
    }
  }
}
