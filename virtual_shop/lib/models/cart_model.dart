import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/datas/cart_product.dart';
import 'package:virtual_shop/models/user_model.dart';

class CartModel extends Model {

  //current user
  UserModel user;

  //products tha are in the cart
  List<CartProduct> products = [];

  //boolean to say to the screen if is loading or not (processing info or not)
  bool isLoading = false;

  //discount data
  String couponCode; //name of the coupon
  int discountPercentage = 0;

  //constructor
  CartModel(this.user){
    if(user.isLoggedIn()) //verify if has an user logged in
      _loadCartItems(); //load cart items when cart is opened
  }

  //turns able to access CartModel from any part of the code without using ScopedModel all the time
  static CartModel of(BuildContext context){
    return ScopedModel.of<CartModel>(context);
  }

  //method to add product
  void addCartItem(CartProduct cartProduct){

    //add product to the list
    products.add(cartProduct);

    //add product to the cart on database using method toMap()
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').add(cartProduct.toMap())
    .then((doc){
      cartProduct.cid = doc.documentID; //get cart id
    });

    notifyListeners(); //update app
  }

  //method to remove product
  void removeCartItem(CartProduct cartProduct){
    //delete cart product from firebase
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).delete();

    //remove from the list
    products.remove(cartProduct);
    
    notifyListeners(); //update app
  }

  //method to decrement a product
  void decProduct(CartProduct cartProduct){
    //decrement cart product quantity
    cartProduct.quantity--;

    //update it on firebase
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners(); //update app
  }

  //method to increment a product
  void incProduct(CartProduct cartProduct){
    //decrement cart product quantity
    cartProduct.quantity++;

    //update it on firebase
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners(); //update app
  }

  //method to save the discount coupon info
  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  //method to update listeners
  void updatePrices(){
    notifyListeners(); //update app
  }

  //method to return the subtotal price
  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null) //if cart has products
        price += c.quantity * c.productData.price;
    }
    return price;
  }

  //method to return the shipping price
  double getShipPrice(){
    return 9.99;
  }

  //method to return the shipping price
  double getDiscount(){
    return getProductsPrice() * (discountPercentage/100);
  }

  //method to finish order
  Future<String> finishOrder() async{
    if(products.length == 0) return null; //return if cart is empty

    isLoading = true;
    notifyListeners(); //update app

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discountPrice = getDiscount();
    double totalPrice = productsPrice + shipPrice - discountPrice;

    DocumentReference refOrder =  await Firestore.instance.collection('orders').add( //get a reference to this order
      {
        'clientId': user.firebaseUser.uid, //get current user id
        'products': products.map((cartProduct)=>cartProduct.toMap()).toList(), //get list of products
        'productsPrice': productsPrice,
        'shipPrice': shipPrice,
        'discount': discountPrice,
        'totalPrice': totalPrice,
        'status': 1 //order status (1 = preparing | 2 = waiting to shipping | 3 = sent | 4 = finished )
      }
    ); //add order to firebase orders collection

    //add order to firebase user
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('orders').document(refOrder.documentID).setData(
      {
        'orderId': refOrder.documentID
      }
    );

    //get a query of the cart from the current user collection
    QuerySnapshot query  = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').getDocuments();

    //get each product from the cart (query)
    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete(); //delete product from firebase
    }

    //delete all products from products list
    products.clear();

    //reset discount percentage
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners(); //update app

    return refOrder.documentID;
  }

  //private method to load all the cart items
  void _loadCartItems() async{
    //get all items
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').getDocuments();

    //return to the products list the items from query as cartProducts
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners(); //update app
  }

}