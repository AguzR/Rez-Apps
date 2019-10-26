import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/views/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name, username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;
  var _autovalidate = false;

  // // belum bisa
  // RegExp _regExp = RegExp(r"[a-zA-Z ]");

  check() {
    var form = _key.currentState;
    if (form.validate()) {
      form.save();
      register();
    } else {
      setState(() {
       _autovalidate = true; 
      });
    }
  }

  showHide() {
    setState(() {
     _secureText = !_secureText; 
    });
  }

  register() async{
    final response = await http.post(BaseUrl.register, body: {
      "name" : name,
      "username" : username,
      "password" : password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage()
      ));
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Form(
        autovalidate: _autovalidate,
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
              padding: EdgeInsets.only(top: 20.0),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please insert your full name";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (e) => name = e,
                    decoration: InputDecoration(
                        hintText: "Full Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.person_outline)),
                  ),
                  Padding(padding: EdgeInsetsDirectional.only(top: 20.0),),
                  TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please insert your username";
                      } else if (!e.contains("@")) {
                        return "Wrong format email for username";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (e) => username = e,
                    decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.account_circle)),
                  ),
                  Padding(padding: EdgeInsetsDirectional.only(top: 20.0),),
                  TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please insert your passsword";
                      } else if (e.length < 8) {
                        return "Password must be at least 8 characters long";
                      } else {
                        return null;
                      }
                    },
                    obscureText: _secureText,
                    onSaved: (e) => password = e,
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                        )),
                  ),
                  Padding(padding: EdgeInsetsDirectional.only(top: 60.0),),
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    child: FlatButton(
                      onPressed: () {
                        check();
                      },
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.purple)),
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsetsDirectional.only(top: 20.0),),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginPage()
                      ));
                    },
                    child: Text("I have a account, Login here"),
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
