import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  //to pass as parameter
  TextComposer(this.sendMessage);

  //function to send message
  final Function({String text, File imgFile}) sendMessage; //optional parameters

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  //textField controller
  final TextEditingController _controller = TextEditingController();

  //to check if has smth in the textField
  bool  _isComposing = false;

  //function to reset TextField
  void _reset(){
    _controller.clear(); //clear textField
    setState(() {
      _isComposing = false; //set as false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async {
                final File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery); //to get image from gallery
                if(imgFile == null) return; //if the action was canceled
                widget.sendMessage(imgFile: imgFile); //calls sendMessage function and pass the imgFile as parameter
              }
          ),
          Expanded( //to occupy the maxim space possible
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: 'Send a Message'),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty; //to change when has smth on textField
                });
              },
              onSubmitted: (text){
                widget.sendMessage(text: text); //calls sendMessage function and pass the text as parameter
                _reset();
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing ? (){
                widget.sendMessage(text: _controller.text); //calls sendMessage function and pass the text as parameter
               _reset();
              } : null, //button is disabled if has nothing in textField-
          ),
        ],
      ),
    );
  }
}
