import 'package:flutter/material.dart';
import 'package:virtual_shop/tabs/home_tab.dart';
import 'package:virtual_shop/tabs/orders_tab.dart';
import 'package:virtual_shop/tabs/places_tab.dart';
import 'package:virtual_shop/tabs/products_tab.dart';
import 'package:virtual_shop/widgets/cart_button.dart';
import 'package:virtual_shop/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  //page controller
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(), //turns off page scrollable
      children: <Widget>[
        Scaffold( //homePage
          body: HomeTab(),
          drawer: CustomDrawer(_pageController), //to see menu options
          floatingActionButton: CartButton() //add cart button to the screen
        ),
        Scaffold( //productsPage
          appBar: AppBar(
            title: Text("Products"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(), //add cart button to the screen
        ),
        Scaffold( //orders page
          appBar: AppBar(
            title: Text('My orders'),
            centerTitle: true
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Places'),
            centerTitle: true
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}