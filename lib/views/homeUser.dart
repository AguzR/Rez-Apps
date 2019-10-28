import 'package:flutter/material.dart';
import 'package:rez_apps/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUsers extends StatefulWidget {
  @override
  _HomeUsersState createState() => _HomeUsersState();
}

enum LoginStatus { notSignIn, signInUsers }

class _HomeUsersState extends State<HomeUsers> {
  LoginStatus _loginStatus = LoginStatus.signInUsers;

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.signInUsers:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.exit_to_app),
              )
            ],
          ),
          body: Container(
            child: Center(
              child: Text("Home Users"),
            ),
          ),
        );
        break;
      case LoginStatus.notSignIn:
        return LoginPage();
        break;
    }
  }
}
