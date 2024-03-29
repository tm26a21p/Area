import 'package:flutter/material.dart';
import 'package:area/request_classes/area.dart';
import 'package:area/create/forms.dart';

class AskUserParamsPage extends StatefulWidget {
  final AreaData data;
  const AskUserParamsPage(this.data, {super.key});

  @override
  State<AskUserParamsPage> createState() => _AskUserParamsPageState();
}

class _AskUserParamsPageState extends State<AskUserParamsPage> {
  Widget getFormWidget(
      String name, String widgetType, Map<String, dynamic> params) {
    if (widgetType == 'text') {
      return TextForm(name, widgetType, params);
    } else if (widgetType == 'datetime-locale') {
      return DateTimeForm(name, widgetType, params);
    } else if (widgetType == 'time') {
      return TimeForm(name, widgetType, params);
    } else if (widgetType == 'email') {
      return EmailForm(name, widgetType, params);
    } else if (widgetType == 'number') {
      return NumberForm(name, widgetType, params);
    } else if (widgetType == 'url') {
      return UrlForm(name, widgetType, params);
    }
    return TextForm(name, widgetType, params);
  }

  List<List> decodeConfig(String config, Map<String, dynamic> params) {
    final List<List> result = [];
    List forms = config.split('|');
    for (String i in forms) {
      List temp = i.split(':');
      List form = [temp[0], temp[1]];
      form.add(getFormWidget(form[0], form[1], params));
      result.add(form);
    }
    return result;
  }

  String encodeConfig(Map<String, dynamic> params) {
    String result = '';
    int i = 0;

    for (var k in params.keys) {
      if (i == 0) {
        result = '${k}:${params[k]}';
        i++;
      } else {
        result = '${result}|${k}:${params[k]}';
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> params = {};
    List<List> formsData = decodeConfig(widget.data.config!, params);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Remplir les champs',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          Container(
            color: Colors.black,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int indexSeparator) {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 300,
                    child: Divider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: formsData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Text(
                      formsData[index][0],
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                    formsData[index][2],
                  ],
                );
              },
            ),
          ),
          Container(
              child: InkWell(
            onTap: () {
              print('\n================================================\n');
              print(params);
              print('\n================================================\n');
              widget.data.params = encodeConfig(params);
              // if (params.length != formsData.length) {
              var nav = Navigator.of(context);
              nav.pop(widget.data);
              nav.pop(widget.data);
              nav.pop(widget.data);
              // }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    ));
  }
}
