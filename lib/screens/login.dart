import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homeScreen.dart';

class Login_Screen extends StatefulWidget {
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  String email;
  String password;
  var _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                MediaQuery.of(context).size.height * .3,
                MediaQuery.of(context).size.width * .05,
                0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Instagram',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  onChanged: (newValue) {
                    email = newValue;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter email'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  onChanged: (newValue) {
                    password = newValue;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Material(
                  color: Colors.blue,
                  child: MaterialButton(
                    child: Text("Login"),
                    onPressed: () async {
                      try {
                        var cur = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return home_screen();
                            },
                          ),
                        );
                      } catch (e) {
                        String errorMessage;
                        if (e.code == 'user-not-found') {
                          errorMessage = ('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              ('Wrong password provided for that user.');
                        }
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Alert Dialog Box"),
                            content: Text("$errorMessage"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("okay"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Dont have an account? ",
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUp();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Sign-Up",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
