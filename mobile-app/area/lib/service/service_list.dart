import 'package:area/service/service_details_page.dart';
import 'package:area/tools/hexColor.dart';
import 'package:flutter/material.dart';
import 'package:area/request_classes/services.dart';

import 'dart:async';
import 'package:area/tools/fetchServices.dart';
import 'package:area/tools/get_image.dart';

class ServiceList extends StatefulWidget {
  final bool isUserCreatingApplet;
  final bool hasUserChosenAction;
  ServiceList(this.isUserCreatingApplet, this.hasUserChosenAction, {super.key});

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  late Future<Services> futureService;
  @override
  void initState() {
    super.initState();
    futureService = fetchServices();
  }

  String cutDescription(String string) {
    String result;
    if (string.length >= 50) {
      result = '${string.substring(0, 50)} ...';
      return result;
    }
    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: FutureBuilder<Services>(
          future: futureService,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 3
                      : 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: (1.5),
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServiceDetailsPage(
                                  snapshot.data!.data![index],
                                  widget.isUserCreatingApplet, widget.hasUserChosenAction)));
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: HexColor(snapshot.data!.data![index].color!),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Hero(
                                  tag: '${snapshot.data!.data![index].iD!}',
                                  child: getImage(
                                      snapshot.data!.data![index].icon!,
                                      BoxFit.fill),
                                ))),
                                Text(
                                  snapshot.data!.data![index].name!,
                                  style: const TextStyle(color: Colors.white),
                                  textScaleFactor: 1.2,
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
        ),
      ),
    );
  }
}
