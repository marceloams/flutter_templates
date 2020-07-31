import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/models/user_model.dart';
import 'package:virtual_shop/screens/login_screen.dart';
import 'package:virtual_shop/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  //receive page controller from home_screen
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    //to make the background color with gradient
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 137, 186, 59),
                Color.fromARGB(255, 255, 255, 255)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(  //menu container
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack( //to makes easy to positioning item
                  children: <Widget>[
                    Positioned( //title
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                          'Flutter\'s\nSkateShop',
                          style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold)
                      ),
                    ),
                    Positioned( //hello msg and log in/sign nup button
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Hi, ${!model.isLoggedIn() ? '' : model.userData['name']}', //custom name
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector( //to make clickable
                                child: Text(
                                    !model.isLoggedIn() ? 'Log in or Sign up >' : 'Log out', //custom button
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                ),
                                onTap: (){
                                  if(!model.isLoggedIn()){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>LoginScreen())
                                    );
                                  }else {
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(), //to separate content
              DrawerTile(Icons.home, 'Home', pageController, 0),
              DrawerTile(Icons.list, 'Products', pageController, 1),
              DrawerTile(Icons.playlist_add_check, 'Orders', pageController, 2),
              DrawerTile(Icons.location_on, 'Places', pageController, 3)
            ],
          )
        ],
      ),
    );
  }
}
