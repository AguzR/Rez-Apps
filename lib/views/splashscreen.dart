import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rez_apps/views/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startSplash() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      // menggunakan pushReplacement agar tidak dapat kembali ke halaman splash
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.fiber_smart_record,
              color: Colors.white,
              size: 70.0,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20.0),),
            Text(
              "Rez Official",
              style: TextStyle(
                  fontSize: 20.0, color: Colors.white, fontFamily: "RopaSans"),
            )
          ],
        ),
      ),
    );
  }
}
