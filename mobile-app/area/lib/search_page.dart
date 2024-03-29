import 'package:area/service/service_list.dart';

import 'package:flutter/material.dart';
import 'package:area/page_title.dart';

class SearchPage extends StatefulWidget {
  final bool isUserCreatingApplet;
  final bool hasUserChosenAction;
  const SearchPage(this.isUserCreatingApplet, this.hasUserChosenAction, {super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Blank space top
          SizedBox(height: 40),
          PageTitle('Explorer'),
          ServiceList(widget.isUserCreatingApplet, widget.hasUserChosenAction),
        ],
      ),
    );
  }
}
