import 'package:flutter/material.dart';
import 'package:virtual_shop/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton( //cart floating button
      child: Icon(Icons.shopping_cart, color: Colors.white), //cart icon
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>CartScreen()) //opens cart screen
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
