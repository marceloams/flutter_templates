import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), //same margin as the products
      child: ExpansionTile( //discount coupon card
        title: Text(
          'Discount Coupon',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard), //left icon
        trailing: Icon(Icons.add), //right icon
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Type your coupon',
                border: OutlineInputBorder()
              ),
              initialValue: CartModel.of(context).couponCode ?? '', //put an existing coupon code if has not one put ''
              onFieldSubmitted: (text){
                Firestore.instance.collection('coupons').document(text).get()
                    .then(
                    (coupon){
                      if(coupon.data != null) { //existing coupon
                        CartModel.of(context).setCoupon(text, coupon.data['percent']); //set coupon info
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${coupon.data['percent']}% discount applied!'),
                                backgroundColor: Theme.of(context).primaryColor
                            )
                        );
                      }else { //non-existed coupon
                        CartModel.of(context).setCoupon(null, 0); //set coupon info
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Coupon does not exist!'),
                                backgroundColor: Colors.red
                            )
                        );
                      }
                    }
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
