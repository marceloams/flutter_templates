import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_shop/models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  //global key to access the form at the sign up button
  final _formKey = GlobalKey<FormState>();

  //global key to access the scaffold at onSuccess and onFail functions
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //controllers to get info from text fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  //controller to validate password
  final _pass2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:Text('Sign Up'),
          centerTitle: true,
        ),
        body:ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading){ //verify if something is being loading
              return Center(child: CircularProgressIndicator());
            }

            return Form( //to validate inputs
              key: _formKey, //global key to be accessed from 'outside'
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField( //full name text field
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Full Name'
                    ),
                    keyboardType: TextInputType.emailAddress, //use email keyboard type
                    validator: (text){ //rule to validate the input data
                      if(text.isEmpty) return 'Invalid Name!';
                    },
                  ),
                  SizedBox(height: 16.0),
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
                      if(text.length<8 || text.isEmpty){
                        return 'Invalid Password! (Must have 8 or more characters)';
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField( //password confirmation text field
                    controller: _pass2Controller,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password'
                    ),
                    obscureText: true, //to hide elements
                    validator: (text){ //rule to validate the input data
                      if(_pass2Controller.text !=_passController.text){
                        return 'Invalid Password! (Passwords must be the same)';
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField( //address text field
                    controller: _addressController,
                    decoration: InputDecoration(
                        hintText: 'Address'
                    ),
                    validator: (text){ //rule to validate the input data
                      if(text.isEmpty) return 'Invalid Address!';
                    },
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        'Sing Up',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          //creating an user map
                          Map<String, dynamic> userData = {
                            'name': _nameController.text,
                            'email': _emailController.text,
                            'address': _addressController.text
                          };

                          model.singUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }

  //function that executes when sing up is a success
  void _onSuccess(){

    //snack bar with success information
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Successfully Signed Up!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2)
      )
    );

    //after 2 sec goes to home screen
    Future.delayed(
        Duration(seconds:2)
    ).then((_){
      Navigator.of(context).pop();
    });
  }

  //function that executes when sing up is a fail
  void _onFail(){
    //snack bar with success information
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text('Failed to Signed Up!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)
        )
    );
  }
}
