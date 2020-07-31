import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {

  //doc of product tale data
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data['icon']),
      ),
      title: Text(snapshot.data['title']),
      trailing: Icon(Icons.arrow_right), //button
      onTap: (){ //navigate to products screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsScreen(snapshot)
          )
        );
      },
    );
  }
}
