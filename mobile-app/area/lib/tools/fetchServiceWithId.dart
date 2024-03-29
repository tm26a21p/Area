import 'package:area/request_classes/serviceWithId.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:area/getIpAddress.dart';

Future<ServiceWithId> fetchServiceWithId(int id) async {
  final String url = getIP() + '/services/${id}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return ServiceWithId.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Request API error');
  }
}
