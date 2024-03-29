import 'package:flutter/material.dart';

import 'package:area/page_title.dart';
import 'package:area/my_applets/applet_card.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          // Blank space top
          SizedBox(height: 40),
          PageTitle('Activité'),
          AppletCard(),
        ],
      ),
    );
  }
}