import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  //order id
  final String orderId;

  //constructor to get the order id
  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>( //DocumentSnapshot because is only one order (one doc)
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(), //gets a snapshot of the order
          builder: (context, snapshot){
            if(!snapshot.hasData){ //if has no data
              return Center(child: CircularProgressIndicator());
            } else {

              int status = snapshot.data['status']; //to get the order status

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Order Code: ${snapshot.data.documentID}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0), //spacing
                  Text(
                    _buildProductsText(snapshot.data)
                  ),
                  SizedBox(height: 4.0),
                  Text(
                      'Order Status:',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCircle('1', 'Preparing', status, 1),
                      line(),
                      _buildCircle('2', 'Transit', status, 2),
                      line(),
                      _buildCircle('3', 'Delivered', status, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      )
    );
  }

  //function to return the products info
  String _buildProductsText(DocumentSnapshot snapshot){
    String text = 'Description:\n'; //add description
    for(LinkedHashMap p in snapshot.data['products']){ //to access the data into the list in the document
      text += '${p['quantity']} x ${p['product']['title']} (\$ ${p['product']['price'].toStringAsFixed(2)})\n'; //add info for each product
    }
    text += 'Total: \$ ${snapshot.data['totalPrice'].toStringAsFixed(2)}'; //add total price
    return text;
  }

  //function to return the order status
  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){

    Color backColor; //grey or blue
    Widget child;

    //4 cases
    if(status < thisStatus){ //this status hasn't yet been reached
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) { //current status = this status
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ) //to define the color
        ],
      );
    } else { //this status has already been done
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column( //returns the widget with the presets info
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

  //function to return a line between the order status
  Widget line(){
    return Container(
        height: 1.0,
        width: 40.0,
        color: Colors.green[500]
    );
 }

}
