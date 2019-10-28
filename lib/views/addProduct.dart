import 'dart:io';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rez_apps/api/server.dart';
import 'package:rez_apps/custom/currency.dart';
import 'package:rez_apps/custom/datePicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddProduct extends StatefulWidget {
  final VoidCallback reload;
  AddProduct(this.reload);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String namaProduct, qty, harga, idUsers;
  final _key = new GlobalKey<FormState>();
  File _imageFile;
  DateTime tgl = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  String pilihTanggal, labelText;

  Future _chooseGalery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  // Future _chooseCamera() async {
  //   var image = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

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
    try {
      var field = "image";
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();

      var uri = Uri.parse(BaseUrl.addproduct);
      final request = http.MultipartRequest("POST", uri);
      request.fields['namaProduct'] = namaProduct;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga.replaceAll(",", '');
      request.fields['idUsers'] = idUsers;
      request.fields['releasepro'] = tgl.toString();

      request.files.add(new http.MultipartFile(field, stream, length,
          filename: path.basename(_imageFile.path)));

      var response = await request.send();
      if (response.statusCode > 2) {
        Fluttertoast.showToast(msg: "Success", toastLength: Toast.LENGTH_SHORT);
        widget.reload();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Failed", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      debugPrint("Error $e");
    }

    // final response = await http.post(BaseUrl.addproduct, body: {
    //   "namaProduct": namaProduct,
    //   "qty": qty,
    //   "harga": harga.replaceAll(",", ""),
    //   "idUsers": idUsers
    // });
    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String message = data['message'];

    // if (value == 1) {
    //   Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    //   widget.reload();
    //   Navigator.pop(context);
    // } else {
    //   Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    // }
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(2012),
        lastDate: DateTime(2099));
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
        width: double.infinity,
        height: 160.0,
        child: Image.asset(
          './images/placeholder.jpg',
          fit: BoxFit.cover,
        ));
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
            Container(
              width: double.infinity,
              height: 160.0,
              child: _imageFile == null
                  ? placeholder
                  : Image.file(_imageFile, fit: BoxFit.cover),
            ),
            MaterialButton(
              color: Colors.white70,
              onPressed: _chooseGalery,
              child: Text("Choose Image"),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
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
              keyboardType: TextInputType.number,
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert Quantity";
                }
                return null;
              },
              onSaved: (e) => qty = e,
              decoration:
                  InputDecoration(labelText: "Quantity", hintText: "Quantity"),
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
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              onSaved: (e) => harga = e,
              decoration:
                  InputDecoration(labelText: "Price", hintText: "Price"),
            ),
            DateDropdwon(
              labelText: labelText,
              valueText: new DateFormat.yMd().format(tgl),
              valueStyle: valueStyle,
              onPressed: (){
                _selectedDate(context);
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            MaterialButton(
              onPressed: () {
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
