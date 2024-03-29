import 'package:area/request_classes/appletWithId.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:area/getIpAddress.dart';

Future<AppletWithId> fetchAppletsWithId(int id) async {
  final String url = getIP() + '/applets/${id}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return AppletWithId.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Request API error');
  }
}
