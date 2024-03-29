import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

final _proxy = FirebaseFunctions.instance.httpsCallable('corsProxy');
// final http.Client _client = http.Client(); // connection closes when using single client...

/// a function that sends a get request to [url] and casts it as [T]
/// request goes through our cors proxy if on web ([kIsWeb] == true)
Future<T?> get<T>({required String url}) async {
  if (kIsWeb) {
    final dynamic data = (await _proxy({'url': url, 'method': 'get'})).data;
    return data is T ? data : null;
  } else {
    final r = await http.get(Uri.parse(url));
    if (r.statusCode == 200) {
      final dynamic data = json.decode(r.body);
      return data is T ? data : null;
    }
    return null;
  }
}
