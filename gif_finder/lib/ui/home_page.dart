import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import page
import 'package:gif_finder/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables
  String _search; //search input
  int _offset = 0;

  //gif request
  Future<Map> _getGifs() async {
    http.Response response;
    //if no search input shows trending
    if (_search == null || _search.isEmpty) {
      response = await http.get(
          "api key here");
    } else {
      //search if has input
      response = await http.get(
          "api key here q=$_search&limit=19&offset=$_offset&rating=g&lang=en");
    }

    //return response.body decoded
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      //print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
          //get image from web
          centerTitle: true),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Search here!",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
                onSubmitted: (text){
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                }, //when click on send button
              )),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  case ConnectionState.none:
                    return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ));
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  //return size of items
  int _getCount(List data){
    if(_search == null) {
      return data.length; //return 19
    } else {
      return data.length + 1; //return 20
    }
  }

  //method to create table with gifs
  Widget _createGifTable(context, snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //how many items can have on horizontal
          crossAxisSpacing: 10.0, //space between the items
          mainAxisSpacing: 10.0, //space between items on vertical
        ),
        itemCount: _getCount(snapshot.data["data"]), //number of items
        itemBuilder: (context, index){ //same as listView.buider
          if(_search == null || index < snapshot.data["data"].length){
            return GestureDetector( //makes possible to click on image
              child: FadeInImage.memoryNetwork( //shows image in less abrupt way
                  placeholder: kTransparentImage, //shows transparent image while image is not loaded
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover
              ),
              onTap: (){ //change to GifPage when click on a gif
                Navigator.push(
                    context,
                    MaterialPageRoute( //rout to the page
                        builder: (context) => GifPage(snapshot.data["data"][index])
                    )
                );
              },
              onLongPress: (){ //shows share option when hold on a gif
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          }else { //if is searching and is on the last item, shows loading more option
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 70.0
                    ),
                    Text(
                        "Loading more...",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset += 19;
                  });
                },
              )
            );
          }
        },
    );
  }
}
