import 'package:flutter/material.dart';
import 'package:rez_apps/views/home.dart';
import 'package:rez_apps/views/login.dart';
import 'package:rez_apps/views/product.dart';
import 'package:rez_apps/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBarz extends StatefulWidget {
  @override
  _BottomBarzState createState() => _BottomBarzState();
}

enum LoginStatus { signIn, notSignIn }

class _BottomBarzState extends State<BottomBarz> with TickerProviderStateMixin {
  TabController tabController;
  LoginStatus _loginStatus = LoginStatus.signIn;

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  String name = "";
  String username = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString("username");
    name = preferences.getString("name");
  }

  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 3);
    super.initState();
    getPref();
  }
  
  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.signIn:
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
          body: TabBarView(
            controller: tabController,
            children: <Widget>[Home(), Product(), Profile()],
          ),
          bottomNavigationBar: Material(
            color: Colors.purple,
            child: TabBar(
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.home),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(Icons.dehaze),
                  text: "Product",
                ),
                Tab(
                  icon: Icon(Icons.person_outline),
                  text: "Profile",
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
