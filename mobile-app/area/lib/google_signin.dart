import 'package:area/setupuser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:area/getIpAddress.dart';
import 'dart:convert';

class GooglesignIn {
  static final USerInfo user = USerInfo();
  static final String backurl = getIP() + '/google/login/native';
  static late GoogleSignIn _googleSignIn;
  static final Map<int, List<String>> table = {
    //scope url: nom associé
    1:["https://www.googleapis.com/auth/contacts.readonly","Google Contacts"],
    2:["https://gmail.googleapis.com","Gmail"],
    3:["", "Date & Time"],
    4:["https://www.googleapis.com/auth/youtube.force-ssl","Youtube"],
    69:["email", "email"],
  };

  static Future<bool> send_auth(String code, String user_id, String service_name, String Scope) async {
    final String backurl = getIP() + '/connect/' + (await user.getId()).toString();
    try {
      print('backurl is: ' + backurl + 'aaa');
      print("codee = " + code);
      print("user id = " + user_id);
      print("service name = " + service_name);
      print("scope = " + Scope);
      Map data = {
        'code': code,
        'user_id': user_id,
        'service_name': service_name,
        'Scope': Scope,
        'redirect_uri': "",
      };
      var rep = await http.post(
        Uri.parse(backurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      print("stat code: " + rep.statusCode.toString());
      final answer = jsonDecode(rep.body.toString());
      print('answeeer is:' + answer.toString());
      return true;
    } catch (e) {
      print("error is $e");
      return false;
    }
  }


  static Future<bool> send_token(String first_name, String last_name, String email, String avatar) async {
    try {
      Map data = {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'avatar': avatar,
      };
      var rep = await http.post(
        Uri.parse(backurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final answer = jsonDecode(rep.body.toString());
      user.setId(answer['id']);
      user.setUser(answer['email'], answer['first_name'], answer['last_name'], true);
      user.setToken(answer['token']);
      user.setAvatar(answer['avatar']);
      return true;
    } catch (e) {
      print("error is $e");
      return false;
    }
  }

  static Future<bool> requestGoogleApi(String? Scope, String? Service_name) async {

    if (Scope == null || Service_name == null)
      return Future.value(false);
    String scope = Scope.toString();
    final String service_name = Service_name.toString();
    scope = scope.split(' ').first;
    print("scope: " + scope);
    print("name: " + service_name);
    //bool isforce = (service_id == 69 ? false: true);
    try {
      _googleSignIn = GoogleSignIn(
        serverClientId: '425480709650-6qd0q0kir1m2vcpmaubgs1tfcuija4u7.apps.googleusercontent.com',
        scopes: scope.split(' '),
        //forceCodeForRefreshToken: isforce,
      );
      if (_googleSignIn.requestScopes([scope]) == true)
        print('cest true');
      else
        print("fallllllse");
      print("google sign init ok");
      final GoogleSignInAccount? gog = await _googleSignIn.signIn();
      if (gog == null) {
        print("crash mdr");
        return Future.value(false);
      } else {
        print("ca a marché");
      }
      final GoogleSignInAccount vraiuser = gog as GoogleSignInAccount;
      print("login success");
      if (vraiuser.email.isNotEmpty == true) {
        final List<String> part = vraiuser.displayName?.split(' ') as List<String>;
        final String first_name = part[0].toString().trim().toString();
        final String last_name = part.sublist(1).join(' ').trim().toString();
        print("name parse ok");
        if (scope == 'email' && service_name == 'email') {
          print("token");
          final String Email = vraiuser.email;
          final String ppurl = vraiuser.photoUrl.toString();
          _googleSignIn.disconnect();
          return send_token(
              first_name, // 1st name
              last_name, // last name
              Email, // user email
              ppurl, // profile picture URL
          );
        } else {
          print("send auth");
          print("mail ===" + vraiuser.email);
          print(vraiuser.toString());
          return send_auth(
            vraiuser.serverAuthCode.toString(), // scope authorization code
            (await user.getId()).toString(), // user ID from our Backend
            service_name, // service name
            scope, // scope URL
          );
        }
      }
      return Future.value(false);
    } catch (error) {
      print('error is ' + error.toString());
      return Future.value(false);
    }
  }

  static dissconect() async {
    if ((await user.getAuthCode()).toString().isNotEmpty)
      _googleSignIn.disconnect();
  }
}
