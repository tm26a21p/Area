import 'package:shared_preferences/shared_preferences.dart';

class USerInfo  {

  //USer General USe
  void setUser(String? email, String? first_name, String? last_name, bool? isloggedin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (email != null) {
      await prefs.setString('email', email);
    }
    if (first_name != null) {
      await prefs.setString('first_name', first_name);
    }
    if (last_name != null) {
      await prefs.setString('last_name', last_name);
    }
    if (isloggedin != null) {
      await prefs.setBool('isloggedin', isloggedin);
    }
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('first_name');
    await prefs.remove('isloggedin');
    await prefs.remove('last_name');
    await prefs.remove('logFBToken');
    await prefs.remove('logTWToken');
    await prefs.remove('logGOToken');
    await prefs.remove('id');
    await prefs.remove('authcode');
  }
  //Getter
  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('email'));
  }

  Future<String> getUserFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('first_name'));
  }

  Future<String> getUserLastName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('last_name'));
  }

  Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isloggedin') == true)
      return Future.value(true);
    else
      return Future.value(false);
  }

  Future<String> getGoogleToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('logGOToken'));
  }

  Future<String> getTwitterToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('logTWToken'));
  }

  Future<String> getFacebookToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('logFBToken'));
  }

  Future<int> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getInt('id'));
  }

  Future<String> getAuthCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('authcode'));
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('token'));
  }

  Future<String> getAvatar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString('avatar'));
  }



  //Setter
  void setUserEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  void setUserFirstName(String first_name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_name', first_name);
  }

  void setUserLastName(String last_name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_name', last_name);
  }

  void setIsLoggedIn(bool isloggedin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isloggedin', isloggedin);
  }

  void setGoogleToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('logGOToken', token);
  }

  void setFacebookToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('logFBToken', token);
  }

  void setTwitterToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('logTWToken', token);
  }

  void setId(int Id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', Id);
  }

  void setAuthCode(String authcode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authcode', authcode);
  }

  void setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  void setAvatar(String avatar) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', avatar);
  }


}