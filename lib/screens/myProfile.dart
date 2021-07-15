import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class myProfile extends StatefulWidget {
  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  var _auth = FirebaseAuth.instance;
  void _onItemTapped(int index) {
    if (index == 0) Navigator.pop(context);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var currUser;
  String val;
  String bio;
  void open_screen() async {
    await _firestore.collection("users").doc(currUser.uid).get().then((value) {
      val = (value.data()['username']);
      bio = (value.data()['bio']);
    });
    setState(() {
      val = val;
      bio = bio;
    });
  }

  Future<QuerySnapshot> getImages() {
    return _firestore.collection("imageURLs").orderBy("time").get();
  }

  @override
  Widget build(BuildContext context) {
    currUser = _auth.currentUser;
    if (val == null || bio == null) open_screen();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Text('$val'),
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
              horizontal: MediaQuery.of(context).size.width * 0),
          child: Text(
            "$val",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontFamily: "Pacifico"),
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      child: Text(
                        "$val",
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context,
                        Animation animation, Animation secondaryAnimation) {
                      return Login_Screen();
                    }, transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return new SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }),
                    (Route route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: Text('Archive'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text('Your Activity'),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: Text('QR Code'),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: Text('Saved '),
            ),
            ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: Text('Close Friends'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: Text('Discover People '),
            ),
          ],
        ),
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person_pin,
                    size: 100.0,
                  ),
                ],
              ),
              Text(
                "$val",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text("$bio"),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                color: Colors.white,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey, width: 0),
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () {},
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('imageURLs')
                    .orderBy("time")
                    .where("username", isEqualTo: val)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("Hello");
                    return GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(3),
                          child: Image.network(snapshot.data.docs[index]["url"],
                              width: MediaQuery.of(context).size.height * 1,
                              height: 250,
                              fit: BoxFit.fill),
                        );
                      },
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  /*return !snapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : */
                },
              ),
              /*FutureBuilder(
                future: getImages(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data.docs[index]["username"] == val) {
                            print("helloi");
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Image.network(
                                        snapshot.data.docs[index]["url"],
                                        width:
                                            MediaQuery.of(context).size.height *
                                                1,
                                        height: 250,
                                        fit: BoxFit.fill),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Text("No data");
                  }
                  return CircularProgressIndicator();
                },
              ),*/
            ],
          ),
        ),
      ),
      /*Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

        ),
      ),*/
    );
  }
}
