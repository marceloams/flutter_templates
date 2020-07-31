import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  //icon and text from navigation button
  final IconData icon;
  final String text;
  final int page;

  //receive page controller from home_screen
  final PageController controller;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material( //to have visual effect
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop(); //closes navigation bar
          controller.jumpToPage(page); //go to the page specified
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page.round() == page ? Theme.of(context).primaryColor : Colors.grey[700], //verify if its the actual page
              ),
              SizedBox(width: 32.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: controller.page.round() == page ? Theme.of(context).primaryColor : Colors.grey[700], //verify if its the actual page
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
