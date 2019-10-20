import 'package:flutter/material.dart';
import 'package:rez_apps/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum LoginStatus { signIn, notSignIn }

class _ProfileState extends State<Profile> {
  LoginStatus _loginStatus = LoginStatus.signIn;
  String name = "", username = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString("username");
    name = preferences.getString("name");
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
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
      case LoginStatus.signIn:
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: <Widget>[
                Text("Full Name : $name \n Username : $username"),
                FlatButton(
                  color: Colors.purple,
                  child: Text("SignOut"),
                  onPressed: (){
                    signOut();
                  },
                )
              ],
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