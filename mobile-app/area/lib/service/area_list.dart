import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:area/request_classes/services.dart';
import 'package:area/request_classes/area.dart';
import 'package:area/getIpAddress.dart';
import 'package:area/create/ask_user_param_page.dart';
import 'package:area/tools/hexColor.dart';

class AreaList extends StatefulWidget {
  final String areaType;
  final ServicesData serviceData;
  final bool isUserCreatingApplet;
  const AreaList(this.areaType, this.serviceData, this.isUserCreatingApplet,
      {super.key});

  @override
  State<AreaList> createState() => _AreaListState();
}

class _AreaListState extends State<AreaList> {
  Future<Area> fetchArea() async {
    final String url = getIP() + '/${widget.areaType}/${widget.serviceData.iD}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Area.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Request API error');
    }
  }

  late Future<Area> futureArea;
  @override
  void initState() {
    super.initState();
    futureArea = fetchArea();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Area>(
      future: futureArea,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.data!.length == 0) {
            return Text('Il n\'y a rien ici');
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                child: InkWell(
                  onTap: () {
                    if (widget.isUserCreatingApplet == true) {
                      var nav = Navigator.of(context);
                      if (snapshot.data!.data![index].config!.length == 0) {
                        nav.pop(snapshot.data!.data![index]);
                        nav.pop(snapshot.data!.data![index]);
                      } else {
                        nav.push(MaterialPageRoute(
                            builder: (context) => (AskUserParamsPage(snapshot.data!.data![index]))
                            ));
                        print('\n${snapshot.data!.data![index].config}\n');

                      }
                    }
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: HexColor(widget.serviceData.color!),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            snapshot.data!.data![index].description!,
                            style: const TextStyle(color: Colors.white),
                            textScaleFactor: 1.6,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
