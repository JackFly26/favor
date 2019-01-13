import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);
  Future<FirebaseUser> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  Auth();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  const LoginPage({Key key, this.auth, this.onSignedIn}) : super(key: key);
  LoginPageState createState() {
    return LoginPageState();
  }
}

enum formMode { LOGIN, SIGNUP }

class LoginPageState extends State<LoginPage> {
  String username, password;
  String errorMessage;
  bool _isIos = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final RegExp unVal =
      RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
  final RegExp pwVal = RegExp(
      r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})");
  formMode mode = formMode.LOGIN;
  _validateAndSubmit(String username, String password) async {
    setState(() {
      errorMessage = "";
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (mode == formMode.LOGIN) {
          userId = (await widget.auth.signIn(username, password)).uid;
          print('Signed in: $userId');
        } else {
          print(password);
          userId = (await widget.auth.signUp(username, password)).uid;
          print('Signed up user: $userId');
        }
        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          if (_isIos) {
            errorMessage = e.details;
          } else
            errorMessage = e.message;
        });
      }
    }
  }

  bool _validateAndSave() {
    return true;
  }

  Widget _showError() {
    if (errorMessage != null && errorMessage.length > 0) {
      return new Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else
      return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login to Favor"),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _key,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "Username/Email"),
                      keyboardType: TextInputType.text,
                      onSaved: (val) => username = val,
                      validator: (val) =>
                          unVal.hasMatch(val) ? null : "Invalid username",
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onSaved: (val) => password = val,
                      validator: (val) =>
                          pwVal.hasMatch(val) ? null : "Invalid password",
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              child: Text(
                                mode == formMode.LOGIN ? "Log In" : "Sign Up",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _key.currentState.save();
                                _validateAndSubmit(username, password);
                              },
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(mode == formMode.LOGIN
                                  ? "Sign Up"
                                  : "Have an account? Sign in"),
                              onPressed: () {
                                _key.currentState.reset();
                                errorMessage = "";
                                setState(() {
                                  mode = mode == formMode.LOGIN
                                      ? formMode.SIGNUP
                                      : formMode.LOGIN;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(top: 20.0),
                    ),
                    _showError(),
                  ],
                ))));
  }
}
