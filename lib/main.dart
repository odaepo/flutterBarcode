import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = "";
  String response = "";

  Future scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.BARCODE
      );

      if (barcodeResult == '-1') {
        Fluttertoast.showToast(
            msg: "Scansione annullata",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        setState(() {
          barcode = barcodeResult;
        });
        await fetchResponseFromAPI(barcode);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Errore nella scansione: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Future fetchResponseFromAPI(String barcode) async {
    try {
      var url = Uri.parse('http://www.miosito.it/getBarrCode/$barcode');
      var response = await http.get(url);
      setState(() {
        this.response = json.decode(response.body);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Errore nella richiesta: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Risposta:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '$response',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => scanBarcode(),
              child: Text('Scansiona un altro codice a barre'),
            ),
          ],
        ),
      ),
    );
  }
}
