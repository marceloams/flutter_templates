import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  //variable
  final Map _gifData; //json map

  //constructor
  GifPage(this._gifData); //gets _gifData from constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_gifData["title"], style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton( //share button
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
            )
          ],
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Image.network(_gifData["images"]["fixed_height"]["url"])
      ),
    );
  }
}
