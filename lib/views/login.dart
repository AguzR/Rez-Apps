import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/views/home.dart';
import 'package:rez_apps/views/register.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username, password;
  final _key = new GlobalKey<FormState>();

  // membuat show hide password
  bool _secureText = true;

  showHide() {
    // jika kondisinya true _secureText kan berubah jadi false
    // jika kondisinya false _secureText kan berubah jadi true
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    var form = _key.currentState;

    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Home()
      ));
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300.0,
              decoration: BoxDecoration(color: Colors.purple),
              child: Icon(
                Icons.fiber_smart_record,
                size: 90.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please insert your username";
                      }
                    },
                    onSaved: (e) => username = e,
                    decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please insert your password";
                      }
                    },
                    obscureText: _secureText,
                    onSaved: (e) => password = e,
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Text("Lupa password ?"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.purple)),
                      color: Colors.purple,
                      onPressed: () {
                        check();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                    child: Text("Create a new account"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(0, size.height, size.width / 4, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return null;
  }
}
