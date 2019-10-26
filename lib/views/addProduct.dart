import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/custom/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  final VoidCallback reload;
  AddProduct(this.reload);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String namaProduct, qty, harga, idUsers;
  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
     idUsers = preferences.getString("id"); 
    });
  }

  checkForm() {
    var form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.addproduct, body: {
      "namaProduct" : namaProduct,
      "qty" : qty,
      "harga" : harga.replaceAll(",", ""),
      "idUsers" : idUsers
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT
      );
      widget.reload();
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Add Product"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert name product";
                }
                return null;
              },
              onSaved: (e)=> namaProduct = e,
              decoration: InputDecoration(
                  labelText: "Name Product", hintText: "Name Product"),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert Quantity";
                }
                return null;
              },
              onSaved: (e)=> qty = e,
              decoration: InputDecoration(
                  labelText: "Quantity", hintText: "Quantity"),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert Price";
                } 
                return null;
              },
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly, CurrencyFormat()
              ],
              onSaved: (e)=> harga = e,
              decoration: InputDecoration(
                  labelText: "Price", hintText: "Price"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            MaterialButton(
              onPressed: (){
                checkForm();
              },
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
