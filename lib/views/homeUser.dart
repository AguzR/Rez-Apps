import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/model/productModel.dart';
import 'package:rez_apps/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeUsers extends StatefulWidget {
  @override
  _HomeUsersState createState() => _HomeUsersState();
}

enum LoginStatus { notSignIn, signInUsers }

class _HomeUsersState extends State<HomeUsers> {
  final _money = NumberFormat("#,##0", "en_US");
  final list = List<ProductModel>();
  var loading = false;
  final GlobalKey<RefreshIndicatorState> _refresh =
      new GlobalKey<RefreshIndicatorState>();
  LoginStatus _loginStatus = LoginStatus.signInUsers;

  Future<void> _readProduct() async {
    list.clear();

    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.readproduct);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final pModel = new ProductModel(
          api['id'],
          api['namaProduct'],
          api['qty'],
          api['harga'],
          api['created_at'],
          api['idUsers'],
          api['name'],
          api['image'],
        );
        list.add(pModel);
      });

      setState(() {
        loading = false;
      });
    }
  }

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
  void initState() {
    super.initState();
    _readProduct();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.signInUsers:
        return Scaffold(
            appBar: AppBar(
              title: Text("Rez Store"),
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
            body: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                            'http://192.168.43.69/rez_apps/upload/' + x.image,
                            width: double.infinity,
                            height: 140.0,
                            fit: BoxFit.cover),
                        Container(
                          height: 30.0,
                          child: Text(
                            x.namaProduct,
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Rp" + _money.format(int.parse(x.harga)),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                            Text(
                              x.qty,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ));
        break;
      case LoginStatus.notSignIn:
        return LoginPage();
        break;
    }
  }
}
