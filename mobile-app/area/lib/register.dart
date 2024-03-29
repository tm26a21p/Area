import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:area/setupuser.dart';
import 'package:area/nav_bar.dart';
import 'package:area/getIpAddress.dart';

class registerr extends StatelessWidget {
  // User data required for registration
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';

  final _formKey = GlobalKey<FormState>();
  final String backurl = getIP() + '/register';
  final USerInfo user = USerInfo();
  //final String backurl = "http://10.0.2.2:8080/register";


  register(BuildContext context) async {

    try {
      //format required to send data
      Map data = {
        'first_name': firstname,
        'last_name': lastname,
        'email': email,
        'password': password,
      };
      var rep = await http.post(
        Uri.parse(backurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final answer = jsonDecode(rep.body.toString());
      user.setUser(answer['data']['email'], answer['data']['first_name'], answer['data']['last_name'], true);
      user.setId(answer['data']['ID']);
      user.setAvatar(answer['data']['avatar']);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavBar()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("error is $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("register"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          buildfirstname(),
          const SizedBox(height: 16),
          buildlastname(),
          const SizedBox(height: 16),
          buildEmail(),
          const SizedBox(height: 32),
          buildPassword(),
          const SizedBox(height: 32),
          buildSubmit(context),
        ]),
      ),
    );
  }

  Widget buildfirstname() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'firstname',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'No First Name ?';
          } else {
            firstname = value.toString();
            return null;
          }
        },
        maxLength: 30,
      );

  Widget buildlastname() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'lastname',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'No last name ?';
          } else {
            lastname = value.toString();
            return null;
          }
        },
        maxLength: 30,
      );

  Widget buildEmail() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
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

  Widget buildSubmit(BuildContext context) => ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            register(context);
          }
        },
        child: const Text('Submit'),
      );
}
