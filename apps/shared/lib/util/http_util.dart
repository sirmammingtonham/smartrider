import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

const corsProxyURL =
    // 'http://localhost:5001/smartrider-4e9e8/us-central1/corsProxy/';
'https://us-central1-smartrider-4e9e8.cloudfunctions.net/corsProxy/';

final http.Client _client = http.Client();

Future<http.Response> get({required String url}) async {
  final http.Response response;
  if (kIsWeb) {
    response = await _client.get(
      Uri.parse('$corsProxyURL$url'),
      headers: {'X-Requested-With': 'XMLHttpRequest'},
    );
  } else {
    response = await _client.get(Uri.parse(url));
  }
  return response;
}
