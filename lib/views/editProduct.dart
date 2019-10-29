import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/custom/currency.dart';
import 'package:rez_apps/custom/datePicker.dart';
import 'package:rez_apps/model/productModel.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;
  EditProduct(this.model, this.reload);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String namaProduct, qty, harga;
  final _key = new GlobalKey<FormState>();
  TextEditingController txtName, txtQty, txtHarga;
  String pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  String tglDate;
  var formatTgl = new DateFormat('yyyy-MM-dd');

  setup() {
    tglDate = widget.model.releasepro;
    txtName = TextEditingController(text: widget.model.namaProduct);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  _checkForm() {
    var form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.updateproduct, body: {
      "namaProduct": namaProduct,
      "qty": qty,
      "harga": harga.replaceAll(",", ""),
      "idProduct": widget.model.id,
      "releasepro" : tglDate
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(2012),
        lastDate: DateTime(2099));
    if (picked != null || picked != tgl) {
      setState(() {
       tgl = picked;
       tglDate = formatTgl.format(tgl);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Edit Product"),
      ),
      body: Form(
        key: _key,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: txtName,
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert name product";
                  }
                  return null;
                },
                onSaved: (e) => namaProduct = e,
                decoration: InputDecoration(
                    labelText: "Name Product", hintText: "Name Product"),
              ),
              TextFormField(
                controller: txtQty,
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert quantity product";
                  }
                  return null;
                },
                onSaved: (e) => qty = e,
                decoration: InputDecoration(
                    labelText: "Quantity", hintText: "Quantity"),
              ),
              TextFormField(
                controller: txtHarga,
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert price product";
                  }
                  return null;
                },
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CurrencyFormat()
                ],
                onSaved: (e) => harga = e,
                decoration: InputDecoration(
                    labelText: "Harga Product", hintText: "Harga Product"),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              DateDropdwon(
                labelText: labelText,
                valueText: tglDate,
                valueStyle: valueStyle,
                onPressed: (){
                  _selectedDate(context);
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              MaterialButton(
                color: Colors.purple,
                onPressed: () {
                  _checkForm();
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
