import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:area/setupuser.dart';
import 'package:http/http.dart' as http;
import 'package:area/getIpAddress.dart';
import 'dart:convert';

class Facebookauth {
  final USerInfo user = USerInfo();
  final String backurl = getIP() + '/facebook/login/mobile';

  void send_token(AccessToken accessToken) async {
    Map dataToSendToBack = {
      'token': accessToken,
    };
    var rep = await http.post(
      Uri.parse(backurl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(dataToSendToBack),
    );
    final answer = jsonDecode(rep.body.toString());
    user.setId(answer['id'] as int);
    // User Data will be sent afterwards

  }

  Future<bool> loginne() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      user.setFacebookToken(accessToken.toString());
      user.setIsLoggedIn(true);
      send_token(accessToken);
      return true;
    } else {
      return false;
    }
  }
}