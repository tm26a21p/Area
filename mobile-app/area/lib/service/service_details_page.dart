import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:area/request_classes/services.dart';
import 'package:area/tools/get_image.dart';
import 'package:area/service/area_list.dart';
import 'package:area/google_signin.dart';
import 'package:area/tools/hexColor.dart';
import 'package:area/getIpAddress.dart';
import 'package:area/setupuser.dart';

class ServiceDetailsPage extends StatefulWidget {
  final ServicesData service_data;
  final bool isUserCreatingApplet;
  final bool hasUserChosenAction;
  const ServiceDetailsPage(
      this.service_data, this.isUserCreatingApplet, this.hasUserChosenAction,
      {super.key});
  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final USerInfo user = USerInfo();
  bool test = false;

  Future<int> getUserId() async {
    var result = await user.getId();
    return result;
  }

  Future<bool> fetchIsUserConnected(String serviceName, int id) async {
    final String url = getIP() + '/tokens/${serviceName}/${id}';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var result = jsonDecode(response.body);
      if (result == true && test == false) {
        setState(() {
          test = true;
        });
      }
      return result;
    } else {
      throw Exception('Request API error');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<int>(
      future: getUserId(),
      builder: (context, userId) {
        if (userId.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Material(
                    elevation: 20,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: HexColor(widget.service_data.color!),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          Hero(
                            tag: "${widget.service_data.iD}",
                            child: SizedBox(
                                height: size.height / 10,
                                child: getImage(
                                  widget.service_data.icon!,
                                  BoxFit.fitHeight,
                                )),
                          ),
                          Text(
                            widget.service_data.name!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width / 40,
                              right: size.width / 40,
                              top: size.height / 40,
                              bottom: size.height / 40,
                            ),
                            child: Text(
                              widget.service_data.description!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (widget.service_data.button!.provider!.isNotEmpty)
                            FutureBuilder<bool>(
                              future: fetchIsUserConnected(
                                  widget.service_data.name!, userId.data!),
                              builder: (context, isUserConnected) {
                                if (isUserConnected.hasData &&
                                    isUserConnected.data == false) {
                                  return GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Text('Se connecter',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    onTap: () {
                                      GooglesignIn.requestGoogleApi(
                                          widget.service_data.button?.scopes,
                                          widget.service_data.name);
                                    },
                                  );
                                } else if (isUserConnected.hasData &&
                                    isUserConnected.data == true) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Text('Connecté',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  );
                                } else if (isUserConnected.hasError) {
                                  return Text('${isUserConnected.error}');
                                }
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                  if (widget.hasUserChosenAction == false)
                    Column(
                      children: [
                        Container(
                          child: Text(
                            "Actions",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            child: AreaList('actions', widget.service_data,
                                widget.isUserCreatingApplet)),
                      ],
                    ),
                  if (widget.hasUserChosenAction) SizedBox(height: 20),
                  if (widget.hasUserChosenAction)
                    Column(
                      children: [
                        Container(
                          child: Text(
                            "Réactions",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            child: AreaList('reactions', widget.service_data,
                                widget.isUserCreatingApplet)),
                      ],
                    )
                ],
              ),
            ),
          );
        } else if (userId.hasError) {
          return Text('${userId.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
