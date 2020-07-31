import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), //same margin as the products
      child: ExpansionTile( //discount coupon card
        title: Text(
          'Calculate Shipping',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.local_shipping), //left icon
        trailing: Icon(Icons.add), //right icon
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Type your zip code',
                  border: OutlineInputBorder()
              ),
              initialValue: '', //put an existing coupon code if has not one put ''
              onFieldSubmitted: (text){

              },
            ),
          )
        ],
      ),
    );
  }
}
