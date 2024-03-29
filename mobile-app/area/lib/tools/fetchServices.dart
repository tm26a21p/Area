import 'package:area/request_classes/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:area/getIpAddress.dart';

Future<Services> fetchServices() async {
  final String url = getIP() + '/services';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Services.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Request API error');
  }
}