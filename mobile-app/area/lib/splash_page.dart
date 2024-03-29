import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  int duration = 1;
  Widget goToPage;

  SplashPage(this.duration, this.goToPage, {super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => goToPage));
    });
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.asset(
            "assets/img/area_logo-removebg.png",
            height: 140,
            width: 140,
          ),
        ),
      ),
    );
  }
}
