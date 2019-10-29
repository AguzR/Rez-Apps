import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/model/cartModel.dart';
import 'package:rez_apps/model/productModel.dart';
import 'package:rez_apps/views/detailProduct.dart';
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
  String idUsers;
  final ex = List<CartModel>();
  String jumlah = "0";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

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
          api['releasepro'],
        );
        list.add(pModel);
      });

      setState(() {
        readCart();
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

  addChart(String idProduct, String harga) async {
    final response = await http.post(BaseUrl.addchart,
        body: {"idUsers": idUsers, "idProduct": idProduct, "harga": harga});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      readCart();
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  readCart() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    final response = await http.get(BaseUrl.readcart + idUsers);
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new CartModel(api['jumlah']);
      ex.add(exp);
      setState(() {
        jumlah = exp.jumlah;
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
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
                Stack(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.shopping_cart),
                    ),
                    jumlah == "0"
                        ? Container()
                        : Positioned(
                            right: 0.0,
                            child: Stack(
                              children: <Widget>[
                                Icon(Icons.brightness_1,
                                    color: Colors.green, size: 20.0),
                                Positioned(
                                  top: 3.0,
                                  right: 6.0,
                                  child: Text(jumlah,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )
                  ],
                ),
                IconButton(
                  onPressed: () {
                    signOut();
                  },
                  icon: Icon(Icons.exit_to_app),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _readProduct,
              key: _refresh,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailProduct(x)
                                ));
                              },
                              child: Hero(
                                tag: x.id,
                                child: Image.network(
                                    'http://192.168.43.69/rez_apps/upload/' +
                                        x.image,
                                    width: double.infinity,
                                    height: 100.0,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
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
                                    fontSize: 13.0,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                              Text(
                                x.qty,
                                style: TextStyle(
                                    fontSize: 11.0,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          // RaisedButton(
                          //   onPressed: () {
                          //     addChart(x.id, x.harga);
                          //   },
                          //   child: Text("Add to Chart",
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontFamily: 'Quicksand',
                          //           fontSize: 10.0,
                          //           fontWeight: FontWeight.bold)),
                          //   color: Colors.green,
                          // )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
        break;
      case LoginStatus.notSignIn:
        return LoginPage();
        break;
    }
  }
}
