import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:toggle_switch/toggle_switch.dart';

import 'dart:async';

import 'package:area/request_classes/appletWithId.dart';
import 'package:area/tools/fetchAppletsWithId.dart';
import 'package:area/getIpAddress.dart';
import 'package:area/setupuser.dart';

class MyAppletsList extends StatefulWidget {
  const MyAppletsList({super.key});

  @override
  State<MyAppletsList> createState() => _MyAppletsListState();
}

class _MyAppletsListState extends State<MyAppletsList> {
  late Future<AppletWithId> futureApplet;
  final USerInfo user = USerInfo();
  late int UserId = 1;

  int getAppletState(bool status) {
    if (status == false) {
      return 1;
    }
    return 0;
  }

  Future getUserId() async {
    var result = await user.getId();
    setState(() {
      UserId = result;
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureApplet = fetchAppletsWithId(UserId);
    final String urlToggle = getIP() + '/applet/toggle/';

    return FutureBuilder<AppletWithId>(
      future: futureApplet,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            snapshot.data!.data![index].name!,
                            style: const TextStyle(color: Colors.white),
                            textScaleFactor: 1.6,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              // Container(
                              //     margin: const EdgeInsets.all(5),
                              //     height: 30,
                              //     child: getImage(
                              //         snapshot
                              //             .data!.data![index].service!.icon!,
                              //         BoxFit.fill)),
                              Text(
                                textAlign: TextAlign.left,
                                'Nom du service',
                                style: const TextStyle(color: Colors.white),
                                textScaleFactor: 1,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: ToggleSwitch(
                            minWidth: 100.0,
                            minHeight: 30,
                            cornerRadius: 20.0,
                            activeBgColors: [
                              [Colors.green[800]!],
                              [Colors.red[800]!]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: getAppletState(
                                snapshot.data!.data![index].status!),
                            totalSwitches: 2,
                            labels: const ['Connecté', 'Déconnecté'],
                            radiusStyle: false,
                            onToggle: (indexToggle) async {
                              await http.put(Uri.parse(
                                  '${urlToggle}${snapshot.data!.data![index].iD}'));
                            },
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const Expanded(
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
