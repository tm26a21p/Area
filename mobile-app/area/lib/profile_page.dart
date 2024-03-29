import 'package:flutter/material.dart';
import 'package:area/setupuser.dart';
import 'package:area/google_signin.dart';
import 'package:area/welcome_page.dart';
import 'package:area/page_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final USerInfo user = new USerInfo();

  Widget profile(BuildContext context) {
    return Text((() {
      return 'Profile';
    })());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            SizedBox(height: 40),
            PageTitle('Mon profile'),
            Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 26)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: Colors.black)))),
                  onPressed: () {
                    GooglesignIn.dissconect();
                    user.removeUser();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          ],
        ),
      );
}
