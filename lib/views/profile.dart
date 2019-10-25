import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String username = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString("username");
    name = preferences.getString("name");
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('images/back.jpg'))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              Text(
                "$name",
                style: TextStyle(fontSize: 18.0, color: Colors.purple),
              ),
              Text(
                "$username",
                style: TextStyle(fontSize: 14.0, color: Colors.purple),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
