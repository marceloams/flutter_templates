import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/datas/cart_product.dart';
import 'package:virtual_shop/datas/product_data.dart';
import 'package:virtual_shop/models/cart_model.dart';
import 'package:virtual_shop/models/user_model.dart';
import 'package:virtual_shop/screens/cart_screen.dart';
import 'package:virtual_shop/screens/login_screen.dart';
import 'package:virtual_shop/widgets/cart_button.dart';

class ProductScreen extends StatefulWidget {

  //product that will be shown
  final ProductData product;

  //constructor to receive the product
  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product); //passing product as parameter
}

class _ProductScreenState extends State<ProductScreen> {

  //product that will be shown
  final ProductData product;

  //constructor to receive the product
  _ProductScreenState(this.product);

  //size tha has been chosen
  String size;

  @override
  Widget build(BuildContext context) {

    //to make easier to use the primary color
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView( //to ,ake it scrollable
        children: <Widget>[
          AspectRatio( //constructor to receive the product
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map( //to transform the url into the img
                  (url){
                    return NetworkImage(url);
                  }
              ).toList(),
              dotSize: 4.0, //size of the image indicator
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false, //to turn off the auto play
            ),
          ),
          Padding(  //for the other infos
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text( //title
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3
                ),
                Text( //price
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16.0), //to separate price and size
                Text( //size label
                  'Size:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox( //to use a static size
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal, //horizontal orientation
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, //only one row
                      mainAxisSpacing: 8.0, //horizontal spacing
                      childAspectRatio: 0.5
                    ),
                    children: product.sizes.map(
                        (s){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                  color: s == size ? primaryColor : Colors.grey[500], //chosen size color is different from the rest of sizes
                                  width: 3.0 //border width
                                )
                              ),
                              width: 50.0,
                              alignment: Alignment.center, //text alignment
                              child: Text(s)
                            ),
                          );
                        }
                    ).toList(),
                  ),
                ),
                SizedBox(height: 16.0), //to separate sizes and add to cart/log in button
                SizedBox( //add to cart/log in button
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size != null ?
                    () { //active button only when a size is chosen
                      if(UserModel.of(context).isLoggedIn()){ //verify if there is a user logged in
                        //creating a cart product
                        CartProduct cartProduct = CartProduct();

                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;
                        cartProduct.category = product.category;
                        cartProduct.productData = product;

                        //add product to the cart
                        CartModel.of(context).addCartItem(cartProduct);

                        //goes to cart screen
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>CartScreen())
                        );
                      } else {
                        Navigator.of(context).push( //goes to login screen
                          MaterialPageRoute(builder: (context)=>LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn() ?
                      'Add to Cart'
                      : 'Log In to Buy',
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                    color: primaryColor, //button color
                    textColor: Colors.white, //text color
                  ),
                ),
                SizedBox(height: 16.0),
                Text( //description label
                  'Description:',
                  style: TextStyle(
                      fontSize: 18.0
                  ),
                ),
                Text( //description
                  product.description,
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
