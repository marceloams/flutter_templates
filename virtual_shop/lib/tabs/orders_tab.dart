import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/user_model.dart';
import 'package:virtual_shop/screens/login_screen.dart';
import 'package:virtual_shop/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //verify if current user is logged in
    if(UserModel.of(context).isLoggedIn()){

      //get user uid
      String uid = UserModel.of(context).firebaseUser.uid;

      //to get all the documents from the collection (DocumentSnapshot -> for one doc)
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('users').document(uid).collection('orders').getDocuments(), //get orders from the specified user
        builder: (context, snapshot){
          if(!snapshot.hasData){ //if it is loading
            return Center(
              child: CircularProgressIndicator()
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc)=>OrderTile(doc.documentID)).toList()  //passing doc by doc and transforming into OrderTile and parse to list
            );
          }
        }
      );

    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon( //removed cart icon
                Icons.view_list,
                size: 80.0,
                color: Theme.of(context).primaryColor
            ),
            SizedBox(height: 16.0), //spacing
            Text( //text
                'Log In to see your Orders!',
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
                  Navigator.of(context).push( //goes to log in screen
                      MaterialPageRoute(builder: (context)=>LoginScreen())
                  );
                },
              ),
            ), //spacing
          ],
        ),
      );
    }

  }
}
