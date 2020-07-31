import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/models/cart_model.dart';

class CartPrice extends StatelessWidget {

  //function to check out
  final VoidCallback buy;

  //constructor to pass the function
  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model){

            //prices variables
            double price = model.getProductsPrice();
            double shipment = model.getShipPrice();
            double discount = model.getDiscount();
            double total = price + shipment - discount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, //to occupy the maximum space available
              children: <Widget>[
                Text(
                  'Order Summary',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Subtotal:'),
                    Text('\$ ${price.toStringAsFixed(2)}')
                  ],
                ),
                Divider(), //spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Shipment:'),
                    Text('\$ ${shipment.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),//spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Discount:'),
                    Row(
                      children: <Widget>[
                        Icon(Icons.remove, color: Colors.red, size: 10.0),
                        Text(' \$ ${discount.toStringAsFixed(2)}')
                      ],
                    )
                  ],
                ),
                Divider(),//spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$ ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0
                      ),
                    )
                  ],
                ),
                RaisedButton(
                  child: Text('Finish Order'),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: buy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
