import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/views/bottombar.dart';
import 'package:rez_apps/views/homeUser.dart';
import 'package:rez_apps/views/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { signIn, notSignIn, singInUsers }

class _LoginPageState extends State<LoginPage> {
  String username, password;
  final _key = new GlobalKey<FormState>();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  var value;
  var _autovalidate = false;

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
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String id = data['id'];
    String usernameApi = data['username'];
    String nameApi = data['name'];
    String level = data['level'];

    if (value == 1) {
      if (level == "1") {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, id, usernameApi, nameApi, level);
        });
      } else {
        setState(() {
          _loginStatus = LoginStatus.singInUsers;
          savePref(value, id, usernameApi, nameApi, level);
        });
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  savePref(
      int value, String id, String username, String name, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("id", id);
      preferences.setString("username", username);
      preferences.setString("name", name);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");

      _loginStatus = value == "1"
          ? LoginStatus.signIn
          : value == "2" ? LoginStatus.singInUsers : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            brightness: Brightness.light,
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
                          } else if (!e.contains("@")) {
                            return "Wrong format email for username";
                          } else {
                            return null;
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
                          } else {
                            return null;
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
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
        break;
      case LoginStatus.signIn:
        return BottomBarz();
        break;
      case LoginStatus.singInUsers:
        return HomeUsers();
        break;
    }
  }
}
