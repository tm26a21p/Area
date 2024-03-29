import 'package:flutter/material.dart';

class AppletCard extends StatelessWidget {
  const AppletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      )
    );
  }
}