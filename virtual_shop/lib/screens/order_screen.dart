import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  //string to save order id
  final String orderId;

  //constructor to get order id
  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Done'),
        centerTitle: true
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            Text(
              'Order Successfully Done!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              )
            ),
            Text(
              'Order Code: ${orderId}',
              style: TextStyle(fontSize: 16.0)
            )
          ],
        ),
      ),
    );
  }
}
