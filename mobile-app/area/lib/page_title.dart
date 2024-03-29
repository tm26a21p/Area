import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String titleText;

  const PageTitle(this.titleText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Blank space top left
        const SizedBox(width: 20),
        Container(
          color: Colors.white10,
          child: Text(
            titleText,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            // textAlign: TextAlign.left
          ),
        ),
      ],
    );
  }
}
