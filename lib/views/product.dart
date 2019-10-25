import 'package:flutter/material.dart';
import 'package:rez_apps/views/addProduct.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Product"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddProduct()
        )),
      ),
    );
  }
}