import 'dart:io';
import 'package:chat/ui/chat_message.dart';
import 'package:chat/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  //key to put in the scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //google sign in object
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //current user object
  FirebaseUser _currentUser;

  //boolean to use on the photo upload
  bool _isLoading = false;

  //to do at initialization
  @override
  void initState() {
    super.initState();

    //to get actual user any time when it changes
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        _currentUser = user;
      });
    });
  }

  //function to login
  Future<FirebaseUser> _getUser() async {

    //verify is has an user logged in
    if(_currentUser != null) return _currentUser;

    try {
      //get the account after sign in
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

      //to get the authentication data from the user account
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      //to connect the user google account with firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
      );

      //log in firebase with the credential
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      //to get firebase user
      final FirebaseUser user = authResult.user;

      //return user tha has just logged in
      return user;

    }catch (e){
      return null;
    }
  }


  //function to send message data to Firebase
  void _sendMessage({String text, File imgFile}) async {  //optional parameters

    //to get current user
    final FirebaseUser user = await _getUser();

    //verify if user is not logged in
    if(user == null){
      //shows a snackBar
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Unable to login. Try again!"),
          backgroundColor: Colors.red,
        )
      );
    }

    //message map
    Map<String, dynamic> data = {
      "uid": user.uid, //user id
      "senderName": user.displayName, //user name
      "senderPhotoUrl": user.photoUrl, //user photo
      "time" : Timestamp.now(), //time when the message was sent
    };

    //to upload a imgFile and add it to the message map
    if(imgFile != null) {
      //to upload an image
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
        user.uid + DateTime.now().millisecondsSinceEpoch.toString()  // to make an unique id
      ).putFile(imgFile);

      //set _isLoading = true then shows a progress indicator
      setState(() {
        _isLoading = true;
      });

      //to wait until task is done and get info about the image that has been uploaded
      StorageTaskSnapshot taskSnapshot = await task.onComplete;

      //to get the img from firebase
      String url = await taskSnapshot.ref.getDownloadURL();

      //add to the message map
      data['imgUrl'] = url;

      //set _isLoading = false then hide progress indicator
      setState(() {
        _isLoading = false;
      });
    }

    //to add a text to the message map
    if(text != null){
      data['text'] = text;
    }

    //to send the message
    Firestore.instance.collection('messages').add(data);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  //to makes possible to use a snackBar
      appBar: AppBar(
        title: Text(
          _currentUser != null ? "Hello, ${_currentUser.displayName}" : "Chat App" //verify if has user logged in to show a custom title
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance.signOut();  //function to sign out account from firebase
              googleSignIn.signOut(); //function to sign out account from google
              //shows a snackBar
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Successfully Sign Out!")
                  )
              );
            },
          ) : Container()
        ],
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('messages').orderBy('time').snapshots(), //order messages by time
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList(); //to invert the list

                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,  //to show info from bottom to top
                      itemBuilder: (context, index){
                        return ChatMessage(
                            documents[index].data,
                            documents[index].data['uid'] == _currentUser?.uid //verify if the message is from the current user
                        );   //pass data to chatMessage page
                      },
                    );
                }
              }
            ),
          ),
          _isLoading ? LinearProgressIndicator() : Container(), //verify if the image is being loaded and while that shows a progress indicator
          TextComposer(
              _sendMessage
          ),
        ],
      )
    );
  }
}
