import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/models/cart_model.dart';
import 'package:virtual_shop/models/user_model.dart';
import 'package:virtual_shop/screens/login_screen.dart';
import 'package:virtual_shop/screens/order_screen.dart';
import 'package:virtual_shop/tiles/cart_tile.dart';
import 'package:virtual_shop/widgets/cart_price.dart';
import 'package:virtual_shop/widgets/discount_card.dart';
import 'package:virtual_shop/widgets/ship_card.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length; //products quantity
                return Text(
                  '${p ?? 0} ${p == 1 ? 'Item' : 'Items'}', //p ?? 0 , if p is null will return 0
                  style: TextStyle(
                    fontSize: 17.0
                  ),
                );
              },
            ),
          )
        ],
      ),
        body: ScopedModelDescendant<CartModel>(
          builder: (context, child, model){
            //there are 4 cases
            if(model.isLoading && UserModel.of(context).isLoggedIn()){ //if screen is being load and has an user logged in
              return Center(child: CircularProgressIndicator());
            } else if(!UserModel.of(context).isLoggedIn()){ //if has not an user logged in
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon( //removed cart icon
                      Icons.remove_shopping_cart,
                      size: 80.0,
                      color: Theme.of(context).primaryColor
                    ),
                    SizedBox(height: 16.0), //spacing
                    Text( //text
                      'Log In to see your Cart!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center
                    ),
                    SizedBox(height: 16.0), //spacing
                    SizedBox( //log in button
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          'Log In',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          Navigator.of(context).push( //goes to loggin screen
                            MaterialPageRoute(builder: (context)=>LoginScreen())
                          );
                        },
                      ),
                    ), //spacing
                  ],
                ),
              );
            } else if(model.products == null || model.products.length == 0){ //if cart is empty
              return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.mood_bad,
                        size: 80.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      Center(
                        child: Text(
                          'Cart is empty!',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    ],
                  )
              );
            } else { //cart has products and has an user logged in
              return ListView(
                children: <Widget>[
                  Column(
                    children: model.products.map(
                        (product){
                          return CartTile(product);
                        }
                    ).toList(),
                  ),
                  ShipCard(),
                  DiscountCard(),
                  CartPrice(() async {
                    //calls method to finish order and get the order id
                    String orderId = await model.finishOrder();

                    if(orderId != null){ //verify if has order id
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder:(context)=>OrderScreen(orderId))
                      );
                    }
                  })
                ],
              );
            }
          },
        )
    );
  }
}
