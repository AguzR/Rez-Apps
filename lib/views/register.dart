import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: ListView(
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
        ],
      ),
    );
  }
}
