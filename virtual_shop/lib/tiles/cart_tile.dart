import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/datas/cart_product.dart';
import 'package:virtual_shop/datas/product_data.dart';
import 'package:virtual_shop/models/cart_model.dart';

class CartTile extends StatelessWidget {

  //cartProduct that will be used
  final CartProduct cartProduct;

  //constructor to get the cartProduct
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    //Content 'screen'
    Widget _buildContent(){

      //to update prices
      CartModel.of(context).updatePrices();

      return Row(
        children: <Widget>[
          Container( //container to specify the size of the image
            padding: EdgeInsets.all(8.0),
            height: 120.0,
            child: Image.network( //image
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded( //to occupy all the remaining space
            child: Container( //to use padding
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text( //title
                    cartProduct.productData.title,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text( //size
                    'Size: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text( //price
                    '\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row( //quantity
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton( //-1 button
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.quantity > 1 ? (){
                            CartModel.of(context).decProduct(cartProduct); //decrement a product
                        } : null, //disable button when has only 1 item
                      ),
                      Text( //price
                        '${cartProduct.quantity.toString()}',
                      ),
                      IconButton( //+1 button
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).incProduct(cartProduct); //increment a product
                        },
                      ),
                      FlatButton( //remove button
                        child: Text('Remove'),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProduct); //remove item from the cart
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ? //verify if has productData already loaded
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('products').document(cartProduct.category).collection('items').document(cartProduct.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              cartProduct.productData = ProductData.fromDocument(snapshot.data); //converting firebase doc into a productData and saving it into the card
              return _buildContent(); //show data
            }else {
              return Container(
                height: 70.0,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          },
        ) :
          _buildContent() //show data
    );
  }
}

