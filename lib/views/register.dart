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
          ClipPath(
            clipper: Clipper(),
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(color: Colors.purple),
            ),
          )
        ],
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return null;
  }

}
