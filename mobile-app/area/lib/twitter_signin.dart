import 'package:area/setupuser.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';
import 'package:area/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:area/getIpAddress.dart';
import 'dart:convert';

class twitter_auth {
  final USerInfo user = new USerInfo();

  final String backurl = getIP() + '/twitter/login/mobile';

  void send_token(String accessToken) async {
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


  Future<bool> loginse(BuildContext context) async {
    try {
      final oauth2 = TwitterOAuth2Client(
        clientId: 'Y3ZGYzFNbmxHUGd4NWw0YWNnbW86MTpjaQ',
        clientSecret: 'LOGQdKNoL29bKdY2Od2St5RWyeHZTztJKZK2z64Yx6rOQhd3qO',
        redirectUri: 'org.example.android.oauth://callback/',
        customUriScheme: 'org.example.android.oauth',
      );
      final response = await oauth2.executeAuthCodeFlowWithPKCE(
        scopes: Scope.values,
      );
      final twitos = v2.TwitterApi(
        bearerToken: response.accessToken,
        oauthTokens: v2.OAuthTokens(
          consumerKey: 'rLrSrQsfKAKbNHu69DFZh5AqG',
          consumerSecret: '3r1kXTw0PzOiVbfexQD5e3JPVaIH6cKGN7qLH4XYPE1rkPwlpq',
          accessToken: '1589378777334808577-fVRxLeToQVFsgLd5gl60hGD78RoZss',
          accessTokenSecret: 'Z3GBD3ox9Nt5Bn3TB9Na4VhGkMWN6xNeTeXUXf9arRpq4',
        ),
        retryConfig: v2.RetryConfig.ofRegularIntervals(
          maxAttempts: 5,
          intervalInSeconds: 3,
        ),
        timeout: Duration(seconds: 20),
      );
        final me = await twitos.users.lookupMe();
        user.setIsLoggedIn(true);
        user.setUserFirstName(me.data.name);
        print("name is " + me.data.name);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavBar()));
      //send_token(response.accessToken);
      return Future.value(true);
    } catch(e) {
      print('twitter error is : ' + e.toString());
      return Future.value(false);
    }
    /*final twitos = v2.TwitterApi(
      bearerToken: response.accessToken,

      oauthTokens: v2.OAuthTokens(
        consumerKey: 'rLrSrQsfKAKbNHu69DFZh5AqG',
        consumerSecret: '3r1kXTw0PzOiVbfexQD5e3JPVaIH6cKGN7qLH4XYPE1rkPwlpq',
        accessToken: '1589378777334808577-fVRxLeToQVFsgLd5gl60hGD78RoZss',
        accessTokenSecret: 'Z3GBD3ox9Nt5Bn3TB9Na4VhGkMWN6xNeTeXUXf9arRpq4',
      ),
      retryConfig: v2.RetryConfig.ofRegularIntervals(
        maxAttempts: 5,
        intervalInSeconds: 3,
      ),
      timeout: Duration(seconds: 20),
    );
    print('twittos api');
    try {
      print('twitototos api');
      final me = await twitos.users.lookupMe();
      user.setIsLoggedIn(true);
      print('yep de tep');
      user.setUserFirstName(me.data.name);
      print("name is " + me.data.name);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NavBar()));
      return Future.value(true);
    } catch(e) {
      print('error is ' + e.toString());
      return Future.value(false);
    }
    return false;*/
  }
  }
