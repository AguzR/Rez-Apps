import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/model/productModel.dart';
import 'package:rez_apps/views/addProduct.dart';
import 'package:http/http.dart' as http;
import 'package:rez_apps/views/editProduct.dart';
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  // membuat currency untuk menampilkan harga cth 15,000 ada komanya
  final _money = NumberFormat("#,##0", "en_US");

  // membuat list dengan identifier ke productmodel
  final list = new List<ProductModel>();

  // membuat var loading untuk menghandel load data
  var loading = false;

  // membuat global key untuk refresh indicator
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  // membuat untuk mengambil datanya
  // untuk bisa refresh swipe method harus Future<void>
  Future<void> _readProduct() async {
    // listnya harus di clear, agar ketika di restart datanya tidak menumpuk
    list.clear();

    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.readproduct);
    //  membuat control flow untuk melihat responsenya
    if (response.contentLength == 2) {
    } else {
      // jika datanya adamembuat variabel baru untuk jsondecode
      final data = jsonDecode(response.body);

      //membuat pengulangan data
      data.forEach(( // variabel
          api) {
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
        // untuk menamilkan data panggil list di isi dengan value pModel
        list.add(pModel);
      });

      // jika datanya sudah ditemukan loadingnya jadi false
      setState(() {
        loading = false;
      });
    }
  }

  dialogDel(String id) {
    AlertDialog alertDialog = new AlertDialog(
      content: Text("Are you sure want to delete this product ?"),
      actions: <Widget>[
        FlatButton(
          color: Colors.blue,
          child: Text("No", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          color: Colors.red,
          child: Text("Yes", style: TextStyle(color: Colors.white)),
          onPressed: () {
            _delete(id);
          },
        )
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  _delete(String id) async {
    final response =
        await http.post(BaseUrl.deleteproduct, body: {"idProduct": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
        Navigator.pop(context);
        _readProduct();
      });
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  // panggil method readProduct, yang di set pada initstate, agar paling pertama dijalankan
  @override
  void initState() {
    super.initState();
    _readProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddProduct(_readProduct)));
        },
      ),
      // set loading true or false
      body: RefreshIndicator(
        onRefresh: _readProduct,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Image.network(
                              'http://192.168.43.69/rez_apps/upload/' + x.image,
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(x.namaProduct,
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                                Text(_money.format(int.parse(x.harga)),
                                    style: TextStyle(fontFamily: "Quicksand")),
                                Text(x.qty,
                                    style: TextStyle(fontFamily: "Quicksand")),
                                Text(x.name,
                                    style: TextStyle(fontFamily: "Quicksand")),
                                Text(x.created_at,
                                    style: TextStyle(fontFamily: "Quicksand")),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditProduct(x, _readProduct)));
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                color: Colors.red,
                                onPressed: () {
                                  dialogDel(x.id);
                                },
                                icon: Icon(Icons.delete),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
