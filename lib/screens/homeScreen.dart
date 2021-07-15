import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'camera.dart';
import 'myProfile.dart';

class home_screen extends StatefulWidget {
  @override
  _home_screenState createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  var _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var currUser;
  String val;
  void open_screen() async {
    await _firestore.collection("users").doc(currUser.uid).get().then((value) {
      val = (value.data()['username']);
    });
    setState(() {
      val = val;
    });
  }

  void callcamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return cameraWork();
        },
      ),
    );
  }

  Future<QuerySnapshot> getImages() {
    return _firestore
        .collection("imageURLs")
        .orderBy("time", descending: true)
        .get();
  }

  void _onItemTapped(int index) {
    if (index == 4)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return myProfile();
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    currUser = _auth.currentUser;
    if (val == null) open_screen();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: FlatButton(
          child: Icon(
            Icons.camera,
          ),
          onPressed: callcamera,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat),
            color: Colors.black,
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
        title: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .15),
          child: Text(
            "Instagram",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontFamily: "Pacifico"),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('imageURLs')
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: EdgeInsets.all(4),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_pin,
                                        size: 30.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]["username"],
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Material(
                                    child: Image.network(
                                        snapshot.data.docs[index]["url"],
                                        width:
                                            MediaQuery.of(context).size.height *
                                                1,
                                        height: 250,
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(45.0),
                                    elevation: 10.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.favorite_border_outlined,
                                          size: 30.0,
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 0,
                                        child: Icon(
                                          Icons.message,
                                          size: 30.0,
                                        ),
                                      ),
                                      MaterialButton(
                                        child: Icon(
                                          Icons.share,
                                          size: 30.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
          },
        ),
        /*child: FutureBuilder(
          future: getImages(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_pin,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  snapshot.data.docs[index]["username"],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Material(
                              child: Image.network(
                                  snapshot.data.docs[index]["url"],
                                  width: MediaQuery.of(context).size.height * 1,
                                  height: 250,
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(45.0),
                              elevation: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.favorite_border_outlined,
                                    size: 30.0,
                                  ),
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  child: Icon(
                                    Icons.message,
                                    size: 30.0,
                                  ),
                                ),
                                MaterialButton(
                                  child: Icon(
                                    Icons.share,
                                    size: 30.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),*/
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            title: Text(''),
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30.0,
            ),
            title: Text(''),
          ),
          new BottomNavigationBarItem(
              icon: Icon(
                Icons.video_collection_outlined,
                size: 30.0,
              ),
              title: Text('')),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
              size: 30.0,
            ),
            title: Text(''),
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.person_pin,
              size: 30.0,
            ),
            title: Text(''),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
