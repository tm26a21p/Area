import 'package:area/request_classes/applet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:area/getIpAddress.dart';

Future<Applet> fetchApplet() async {
  final String url = getIP() + '/areas';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Applet.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Request API error');
  }
}
