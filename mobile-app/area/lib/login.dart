import 'package:area/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:area/setupuser.dart';
import 'package:area/nav_bar.dart';
import 'package:area/getIpAddress.dart';

class loginn extends StatelessWidget {
  //Class parameters
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  final String backurl = getIP() + '/login';

  //Class main method
  login(BuildContext context) async {
    final USerInfo user = new USerInfo();

    try {
      // Format parameters
      Map dataToSendToBack = {
        'email': email,
        'password': password,
      };
      var rep = await http.post(
        Uri.parse(backurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(dataToSendToBack),
      );
      final answer = jsonDecode(rep.body.toString());
      print("answer login is " + answer.toString());
      // SAVE usr data
      user.setUser(answer['user']['email'], answer['user']['first_name'], answer['user']['last_name'], true);
      user.setId(answer['user']['id']);
      user.setAvatar(answer['user']['avatar']);
      print("bien set");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("login error is $e");
    }
  }


  //Graphical part
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("login"),
    ),
    body:
    //Widget Body is a Form to facilitate Data entry
    Form(
      // key is the parameter used to verify the data is correctly formated
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildEmail(),
          const SizedBox(height: 32),
          buildPassword(),
          const SizedBox(height: 32),
          buildSubmit(context),
          RichText(
            text:
              TextSpan(
                text: 'No account ?',
                recognizer: TapGestureRecognizer()
                ..onTap = () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => registerr()));
                },
                style:
                  const TextStyle(
                    color: Colors.red,
                ),
              ), 
          ),
        ],
      ),
    ),
  );

  Widget buildEmail() => TextFormField(
    decoration: const InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(),
    ),
    // only alphanumeric characters are accepted in the email address & it must contain a @
    validator: (value) {
      const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
      final regExp = RegExp(pattern);
      if (value.toString().isEmpty) {
        return 'Enter an email';
      } else if (!regExp.hasMatch(value.toString())) {
        return 'Enter a valid email';
      } else {
        email = value.toString();
        return null;
      }
    },
    keyboardType: TextInputType.emailAddress,
  );

  Widget buildPassword() => TextFormField(
    decoration: const InputDecoration(
      labelText: 'Password',
      border: OutlineInputBorder(),
    ),
    // password musntn't be empty
    validator: (value) {
      if (value.toString().isEmpty) {
        return 'No Password ?';
      } else {
        password = value.toString();
        return null;
      }
    },
    keyboardType: TextInputType.visiblePassword,
    obscureText: true,
  );

  // if the Data entry Conditions are not met, their corresponding cases glow red & data is not sent

  Widget buildSubmit(BuildContext context) => ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        login(context);
      }
    },
    child: const Text('Submit'),
  );
}