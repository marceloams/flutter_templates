import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/datas/product_data.dart';
import 'package:virtual_shop/tiles/product_tile.dart';
import 'package:virtual_shop/widgets/cart_button.dart';

class ProductsScreen extends StatelessWidget {

  //doc to indicate the title and id of the product
  final DocumentSnapshot snapshot;

  ProductsScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data['title']),
          centerTitle: true,
          bottom: TabBar( //to shows the tab options
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on)), //grid format
              Tab(icon: Icon(Icons.list)) //list format
            ]
          )
        ),
          body: FutureBuilder<QuerySnapshot>( //to show the products
            future: Firestore.instance.collection('products').document(snapshot.documentID).collection('items').getDocuments(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              } else {
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(), //disable scrollable interaction
                  children: <Widget>[
                    GridView.builder( //grid view option
                      padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //number of items per row
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID; //get category
                          return ProductTile('grid', data);
                        }
                    ),
                    ListView.builder( //list view option
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID; //get category
                          return ProductTile('list', data);
                        }
                    )
                  ],
                );
              }
            },
          ),
          floatingActionButton: CartButton() //add cart button to the screen
      ),
    );
  }
}
