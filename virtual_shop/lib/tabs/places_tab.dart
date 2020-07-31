import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('places').getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){ //verify if it is empty
          return Center(child: CircularProgressIndicator()); // shows it while is loading
        } else {
          return ListView(
            children: snapshot.data.documents.map((doc)=>PlaceTile(doc)).toList(), //passing doc by doc and transforming into PlaceTile and parse to list
          );
        }
      },
    );
  }
}
