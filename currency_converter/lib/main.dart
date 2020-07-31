import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:async/async.dart";
import "dart:convert";

//api link
const request = "api key";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )
    ),
  ));
}

//Function to get a future info
Future<Map> getData() async {
  //get and decode response
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //controllers
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final poundController = TextEditingController();

  //money variables
  double dollar;
  double euro;
  double pound;

  //methods
  void _realChanged(String text){
    //if input is empty
    if(text.isEmpty){
      _clearAll();
      return;
    }

    //get real input
    double real = double.parse(text);

    //convert and print
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    poundController.text = (real/pound).toStringAsFixed(2);
  }

  // (money*this.money) -> is to get the valor in BRL

  void _dollarChanged(String text){
    //if input is empty
    if(text.isEmpty){
      _clearAll();
      return;
    }

    //get dollar input
    double dollar = double.parse(text);

    //convert and print
    realController.text = (dollar*this.dollar).toStringAsFixed(2);
    euroController.text = ((dollar*this.dollar)/euro).toStringAsFixed(2);
    poundController.text = ((dollar*this.dollar)/pound).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    //if input is empty
    if(text.isEmpty){
      _clearAll();
      return;
    }

    //get real input
    double euro = double.parse(text);

    //convert and print
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dollarController.text = ((euro*this.euro)/dollar).toStringAsFixed(2);
    poundController.text = ((euro*this.euro)/pound).toStringAsFixed(2);
  }

  void _poundChanged(String text){
    //if input is empty
    if(text.isEmpty){
      _clearAll();
      return;
    }

    //get real input
    double pound = double.parse(text);

    //convert and print
    realController.text = (pound*this.pound).toStringAsFixed(2);
    euroController.text = ((pound*this.pound)/euro).toStringAsFixed(2);
    dollarController.text = ((pound*this.pound)/dollar).toStringAsFixed(2);
  }

  //clear all the inputs
  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
    poundController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ BRL Converter \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Loading data...",
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
            default:
              if(snapshot.hasError){
                return Center(
                    child: Text(
                      "Error on loading data :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
              } else {
                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                pound = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextField("BRL", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildTextField("USD", "US\$ ", dollarController, _dollarChanged),
                      Divider(),
                      buildTextField("EUR", "€ ", euroController, _euroChanged),
                      Divider(),
                      buildTextField("GBP", "£ ", poundController, _poundChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

//text field builder to put different types of money
buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
      ),
      style: TextStyle(
          color: Colors.amber,
          fontSize: 25.0
      ),
      controller: c,
      onChanged: f,
      keyboardType: TextInputType.numberWithOptions(decimal: true)
  );
}
