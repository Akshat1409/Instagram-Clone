import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _auth = FirebaseAuth.instance;

  String email;
  String password;
  String username;
  String bio;
  FirebaseFirestore fStore;
  Future<void> getUserDoc() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var user = await _auth.currentUser;
    DocumentReference ref = await _firestore.collection('users').doc(user.uid);

    print(user.uid);
    return ref.set({'username': username, 'bio': bio});
  }

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
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (newValue) {
                    email = newValue;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  //obscureText: true,
                  onChanged: (newValue) {
                    username = newValue;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'user name'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  onChanged: (newValue) {
                    bio = newValue;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter your bio'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  obscureText: true,
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
                    child: Text("Sign up"),
                    onPressed: () async {
                      print(email);
                      print(password);
                      print(username);
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        String userid = _auth.currentUser.uid;

                        print(userid);

                        if (newUser != null) {
                          getUserDoc();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return home_screen();
                              },
                            ),
                          );
                        }
                      } catch (e) {
                        String errorMessage;
                        if (e.code == 'weak-password') {
                          errorMessage = ('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          errorMessage =
                              ('The account already exists for that email.');
                        }
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Error"),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
