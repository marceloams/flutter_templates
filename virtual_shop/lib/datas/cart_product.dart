import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_shop/datas/product_data.dart';

class CartProduct {

  String cid; //cart id
  String category; //product category
  String pid; //product id
  int quantity;
  String size;

  ProductData productData; //product data

  //empty constructor
  CartProduct();

  //constructor
  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data['category'];
    pid = document.data['pid'];
    quantity = document.data['quantity'];
    size = document.data['size'];
  }

  Map<String, dynamic> toMap(){
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'product': productData.toResumedMap(),
    };
  }

}