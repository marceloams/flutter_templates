import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/screens/home_screen.dart';
import 'package:virtual_shop/screens/login_screen.dart';
import 'package:virtual_shop/screens/signup_screen.dart';

import 'models/cart_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(), //any part of the code has access to the user model
      child:  ScopedModelDescendant<UserModel>( //to update every time that the current user is changed
        builder: (context, child, model){
          return ScopedModel<CartModel>(  //any part of the code has access to the cart model
            model: CartModel(model),
            child: MaterialApp(
                title: 'Flutter\'s SkateShop',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    primaryColor: Color.fromARGB(255, 4, 125, 141) //custom color
                ),
                debugShowCheckedModeBanner: false, //to hide debug banner
                home: HomeScreen()
            ),
          );
        }
      )
    );
  }
}