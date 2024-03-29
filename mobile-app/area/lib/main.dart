import 'package:area/nav_bar.dart';
import 'package:area/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:area/welcome_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        backgroundColor: Colors.black,
        fontFamily: 'Tommy',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      color: Colors.black,

       home: SplashPage(2, const WelcomePage()),
      // home: const NavBarP(),
    );
  }
}
