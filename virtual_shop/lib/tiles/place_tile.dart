import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {

  //snapshot of a place
  final DocumentSnapshot snapshot;

  //constructor to get the place snapshot
  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              snapshot.data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight:FontWeight.bold
                  ),
                ),
                Text(
                  snapshot.data['address'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 17.0
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Pin on Map',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                padding: EdgeInsets.zero,
                onPressed: (){ //to open google maps on the shop address
                  launch('https://www.google.com/maps/search/?api=1&query=${snapshot.data['latitude']},${snapshot.data['longitude']}');
                }
              ),
              FlatButton(
                child: Text(
                  'Call',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                padding: EdgeInsets.zero,
                onPressed: (){ //to open the call screen on the shop number
                  launch('tel:${snapshot.data['phone']}');
                }
              )
            ],
          )
        ],
      ),
    );
  }
}
