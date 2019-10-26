import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/model/productModel.dart';
import 'package:rez_apps/views/addProduct.dart';
import 'package:http/http.dart' as http;
import 'package:rez_apps/views/editProduct.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  // membuat list dengan identifier ke productmodel
  final list = new List<ProductModel>();

  // membuat var loading untuk menghandel load data
  var loading = false;

  // membuat global key untuk refresh indicator
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(x.namaProduct,
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                                Text(x.harga,
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
                                    builder: (context) => EditProduct(x, _readProduct)
                                  ));
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                color: Colors.red,
                                onPressed: () {},
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
