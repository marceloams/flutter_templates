import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model{

  //to simplify the code use _auth instead of FirebaseAuth.instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  //attribute that will have the firebase user
  FirebaseUser firebaseUser;

  //map tha has the user data
  Map<String, dynamic> userData = Map();

  //boolean to say to the screen if is loading or not (processing info or not)
  bool isLoading = false;

  //turns able to access UserModel from any part of the code without using ScopedModel all the time
  static UserModel of(BuildContext context){
    return ScopedModel.of<UserModel>(context);
  }

  //load current user
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  //sign up method
  void singUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail()}) async {//put all parameters as optional to makes possible
    isLoading = true;                                                                                                                                   // to put in any order and adding @required to make
    notifyListeners(); //update screen                                                                                                                  //  all them obligatory again

    //try to create an user
    _auth.createUserWithEmailAndPassword(
        email: userData['email'], //pass email from data
        password: pass //and password
    ).then((user) async{ //if its ok
      firebaseUser = user; //gets firebase user

      //save the user info
      await _saveUserData(userData);

      onSuccess();  //calls success function
      isLoading = false;
      notifyListeners(); //update screen
    }).catchError((e){ //if it is not ok
      onFail(); //calls fail function
      isLoading = false;
      notifyListeners(); //update screen
      print(e);
    });
  }

  //sign in method
  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async { //same thing as singUp method
    isLoading = true;
    notifyListeners(); //update screen

    //try to sign in with email and password
    await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass
    ).then((user) async{ //if it is ok
      firebaseUser = user;//gets firebase user

      await _loadCurrentUser(); //load user to update userData

      onSuccess();
      isLoading = false;
      notifyListeners(); //update screen
    }).catchError((e){ //if it is not ok
      onFail();

      isLoading = false;
      notifyListeners(); //update screen
    });
  }

  //sign out method
  void signOut() async {
    await _auth.signOut(); //sign out command

    //reset variables
    userData = Map();
    firebaseUser = null;

    notifyListeners(); //update screen
  }

  //recovery password method
  void recoveryPass(String email) {
    _auth.sendPasswordResetEmail(email: email); //command to reset email
  }

  //has user logged in method
  bool isLoggedIn() {
    return firebaseUser != null; //return if has or not an user logged in
  }

  //private method to save the user info
  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData; //save user data
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData(userData); //save data on the firebase
  }

  //private method
  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null){ //if there is no user saved on firebaseUser
      firebaseUser = await _auth.currentUser(); //get current user
    }

    if(firebaseUser!=null){ //if there is current user
      if(userData['name']==null){
        DocumentSnapshot docUser = await Firestore.instance.collection('users').document(firebaseUser.uid).get(); //create a doc of the user
        userData = docUser.data; //get data from doc
      }
    }
    notifyListeners(); //update screen
  }

}