import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/models/user_model.dart';
import 'package:virtual_shop/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //global key to access the form at the log in button
  final _formKey = GlobalKey<FormState>();

  //global key to access the scaffold at onSuccess and onFail functions
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //controllers to get info from text fields
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:Text('Login'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SIGN UP',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context)=>SignUpScreen()
                )
              );
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading){
            return Center(child: CircularProgressIndicator());
          }
          return Form( //to validate inputs
            key: _formKey, //global key to be accessed from 'outside'
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField( //email text field
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'E-mail'
                  ),
                  keyboardType: TextInputType.emailAddress, //use email keyboard type
                  validator: (text){ //rule to validate the input data
                    if(text.isEmpty || !text.contains('@')) return 'Invalid E-mail!';
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField( //password text field
                  controller: _passController,
                  decoration: InputDecoration(
                      hintText: 'Password'
                  ),
                  obscureText: true, //to hide elements
                  validator: (text){ //rule to validate the input data
                    if(text.length<8 || text.isEmpty) return 'Invalid Password (Must have 8 or more characters)';
                  },
                ),
                Align( //to align the forgot password button
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      'Forgot my password',
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      if(_emailController.text.isEmpty){ //verify if email input is empty
                        //snack bar with success information
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                                content: Text('Enter your e-mail to recover your account!'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2)
                            )
                        );
                      } else {
                        model.recoveryPass(_emailController.text); //method to recovery email
                        //snack bar with success information
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                                content: Text('Take a look in your e-mail inbox!'),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: 2)
                            )
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      if(_formKey.currentState.validate()){}

                      model.signIn(
                        email: _emailController.text,
                        pass: _passController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }

  //function that executes when sing up is a success
  void _onSuccess(){
    Navigator.of(context).pop();
  }

  //function that executes when sing up is a fail
  void _onFail() {
    //snack bar with success information
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text('Failed to Log in!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)
        )
    );
  }
}
