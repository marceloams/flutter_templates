import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //height and weight controllers objects
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  //Key to validate inputs
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //variables
  String _infoText = "Put your data!";

  //reset method
  void _resetFields(){
    weightController.text = "";
    heightController.text = "";

    setState(() {
      _infoText = "Put your data!";
      _formKey = GlobalKey<FormState>();
    });
  }

  //calculate method
  void _calculate(){
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      double bmi = weight / (height * height);
      debugPrint("BMI = $bmi");

      if(bmi < 18.5){
        _infoText = "Underweight! (${bmi.toStringAsPrecision(4)})";
      }else if(bmi >= 18.5 && bmi < 25){
        _infoText = "Normal! (${bmi.toStringAsPrecision(4)})";
      }else if(bmi >= 25 && bmi < 30){
        _infoText = "Overweight! (${bmi.toStringAsPrecision(4)})";
      }else if(bmi >= 30 && bmi < 35){
        _infoText = "Obesity class 1! (${bmi.toStringAsPrecision(4)})";
      }else if(bmi >= 35 && bmi < 40){
        _infoText = "Obesity class 2! (${bmi.toStringAsPrecision(4)})";
      }else if(bmi >= 40){
        _infoText = "Obesity class 3! (${bmi.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                  Icons.person,
                  size: 120.0,
                  color: Colors.deepOrange
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                InputDecoration(
                    labelText: "Weight (Kg)",
                    labelStyle: TextStyle(color: Colors.deepOrange)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  if(value.isEmpty){
                    return "Put your weight!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                InputDecoration(
                    labelText: "Height (cm)",
                    labelStyle: TextStyle(color: Colors.deepOrange)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  if(value.isEmpty){
                    return "Put you height!";
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          _calculate();
                        }
                      },
                      child: Text("Calculate", style: TextStyle(color: Colors.white, fontSize: 25.0)),
                      color: Colors.deepOrange,
                    ),
                  )
              ),
              Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 25.0)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
