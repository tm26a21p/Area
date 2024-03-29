import 'package:area/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:area/request_classes/area.dart';
import 'package:area/getIpAddress.dart';
import 'package:area/setupuser.dart';

class ValidationPage extends StatefulWidget {
  final List<AreaData> selectedAreas;
  ValidationPage(this.selectedAreas, {super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  String? nameOfApplet;
  final USerInfo user = USerInfo();
  late int UserId = 1;
  final String backurl = getIP() + '/applet/';

  void postNewApplet() async {
    List<AreaData> reactions = List.from(widget.selectedAreas);
    reactions.removeAt(0);
    Map dataToSendToBack = {
      'user_id': UserId,
      'name': nameOfApplet,
      'action': widget.selectedAreas[0],
      'reactions': reactions,
    };
    try {
      print('\nCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC\n');
      print(reactions[0].params);
      print('\nCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC\n');
      var rep = await http.post(
        Uri.parse('${backurl}${UserId}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(dataToSendToBack),
      );
      final answer = jsonDecode(rep.body.toString());
      print(answer);
    } catch (e) {
      print(e);
    }
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: [
        AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Vérifier et terminer',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            )),
        Material(
          color: Colors.black,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Quel est le titre de votre applet ?',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Card(
                  color: Colors.black,
                  child: TextFormField(
                    onChanged: (value) {
                      nameOfApplet = value.toString();
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.white),
                      helperStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      fillColor: Colors.white,
                      // hintColor: ,
                    ),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Ajoutez un titre à l\'applet';
                      } else {
                        nameOfApplet = value.toString();
                        return null;
                      }
                    },
                    maxLength: 140,
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            print('\n===============================\n');
            print(UserId);
            print('\n===============================\n');
            for (AreaData area in widget.selectedAreas) {
              print(area.params);
            }
            postNewApplet();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => (NavBar())));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                child: const Text(
                  'Terminer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
