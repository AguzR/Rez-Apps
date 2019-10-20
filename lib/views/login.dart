import 'package:flutter/material.dart';
import 'package:rez_apps/views/register.dart';
// import 'package:rez_apps/views/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          ClipPath(
            clipper: LCliper(),
            child: Container(
              width: double.infinity,
              height: 300.0,
              decoration: BoxDecoration(color: Colors.purple),
              child: Icon(
                Icons.fiber_smart_record,
                size: 90.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
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
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(
                        Icons.lock_open,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    InkWell(
                      onTap: (){},
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
                    onPressed: () {},
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 30.0),),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => RegisterPage()
                    ));
                  },
                  child: Text("Create a new account"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LCliper extends CustomClipper<Path> {
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
