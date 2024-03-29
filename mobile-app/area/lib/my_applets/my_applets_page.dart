import 'package:flutter/material.dart';

import 'package:area/page_title.dart';
import 'package:area/my_applets/my_applets_list.dart';

class MyAppletsPage extends StatefulWidget {
  const MyAppletsPage({super.key});

  @override
  State<MyAppletsPage> createState() => _MyAppletsPageState();
}

class _MyAppletsPageState extends State<MyAppletsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:const [
          // Blank space top
          SizedBox(height: 40),
          PageTitle('Mes applets'),
          MyAppletsList(),
        ],
      ),
    );
  }
}
