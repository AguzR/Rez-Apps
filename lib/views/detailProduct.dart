import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/model/productModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduct extends StatefulWidget {
  final ProductModel model;
  DetailProduct(this.model);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  final _money = new NumberFormat('#,##0', 'en_US');
  TextStyle _textDet = TextStyle(
      fontFamily: 'Quicksand', fontSize: 12.0, fontWeight: FontWeight.bold);
  String desc =
      "The HARPOON RGB mouse is built to perform, featuring a 6000 DPI optical gaming sensor with advanced tracking for precise control and lightweight, contoured design to support the quickest of movements.";
  String idUsers;

  addChart(String idProduct, String harga) async {
    final response = await http.post(BaseUrl.addchart,
        body: {"idUsers": idUsers, "idProduct": idProduct, "harga": harga});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBox) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 240.0,
            floating: true,
            pinned: true,
            backgroundColor: Colors.purple,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.model.id,
                child: Image.network(
                  'http://192.168.43.69/rez_apps/upload/' + widget.model.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ];
      },
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 20.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model.namaProduct,
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rp" + _money.format(int.parse(widget.model.harga)),
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.grey.withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Product Detail",
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          children: <Widget>[
                            Text(
                              "Product Name : ",
                              style: _textDet,
                            ),
                            Text(
                              widget.model.namaProduct,
                              style: _textDet,
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        Row(
                          children: <Widget>[
                            Text(
                              "Product Stock : ",
                              style: _textDet,
                            ),
                            Text(
                              widget.model.qty,
                              style: _textDet,
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        Row(
                          children: <Widget>[
                            Text(
                              "Release Date : ",
                              style: _textDet,
                            ),
                            Text(
                              widget.model.releasepro,
                              style: _textDet,
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        Text("Description : ", style: _textDet),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        Text(
                          desc,
                          style: _textDet,
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Material(
                      color: Colors.green,
                      child: MaterialButton(
                        onPressed: () {},
                        child: Text(
                          "Chat",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Material(
                        color: Colors.purple,
                        child: MaterialButton(
                          onPressed: () {
                            addChart(widget.model.id, widget.model.harga);
                          },
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
