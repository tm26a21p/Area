import 'package:flutter/material.dart';
import 'package:area/register.dart';
import 'package:area/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:area/setupuser.dart';
import 'package:area/nav_bar.dart';
import 'package:area/google_signin.dart';
import 'package:area/facebook_signin.dart';
import 'package:area/twitter_signin.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final USerInfo localUser = USerInfo();
  final Facebookauth localfb = Facebookauth();
  final twitter_auth localtw = twitter_auth();

  _WelcomePageState() {
    print("im in welcome page");
  }
  //on homepage, initialize User data
  tagglesignin() async {
    print("poyo locco");
    bool res = await GooglesignIn.requestGoogleApi("email", "email");
    if (res == false) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          padding: const EdgeInsets.all(16),
          leading: const Icon(
            Icons.info,
            color: Colors.black,
            size: 32,
          ),
          backgroundColor: Colors.yellow,
          contentTextStyle: TextStyle(color: Colors.black, fontSize: 12),
          content: const Text("Couldn't login to Google"),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text("Dismiss"),
            ),
          ],
        ),
      );
    } else if (res == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              SizedBox(height: 100),
              Text(
                'Bienvenue dans AREA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 26)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () async {
                        if (localUser.getIsLoggedIn() != Future.value(true)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => registerr()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBar()));
                        }
                      },
                      child: const Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 26)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () async {
                        if (localUser.getIsLoggedIn() != Future.value(true)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginn()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBar()));
                        }
                      },
                      child: const Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 26)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: Colors.white)))),
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Sign In With Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
                      ),
                      onPressed: () => tagglesignin(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 26)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: Colors.white)))),
                        icon: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue,
                        ),
                        label: Text(
                          'Sign in with Facebook',
                          style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          if (localfb.loginne() == Future.value(true)) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavBar()));
                          }
                        }),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 26)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: Colors.white)))),
                        icon: FaIcon(
                          FontAwesomeIcons.twitter,
                          color: Colors.cyan,
                        ),
                        label: Text(
                          'Sign in with Twitter',
                          style: TextStyle(color: Colors.white, fontFamily: 'Tommy'),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          bool res = await localtw.loginse(context);
                          if (res == true) {
                            print("teleportation");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavBar()));
                          } else {
                            print("ya un pb poto");
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
