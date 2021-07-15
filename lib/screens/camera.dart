import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

/*
class CameraClick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Image Picker',
      home: cameraWork(),
    );
  }
}
*/
class cameraWork extends StatefulWidget {
  @override
  cameraWorkState createState() => new cameraWorkState();
}

class cameraWorkState extends State<cameraWork> {
  var _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String username;
  var currUser;
  firebase_storage.Reference ref;
  CollectionReference imgRef;
  File _image;
  int _selectedIndex = 0;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    currUser = _auth.currentUser;
    open_screen();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }

  void open_screen() async {
    await _firestore.collection("users").doc(currUser.uid).get().then((value) {
      username = (value.data()['username']);
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    String filename = basename(_image.path);
    ref =
        firebase_storage.FirebaseStorage.instance.ref().child('post/$filename');
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp

    DateTime myDateTime = myTimeStamp.toDate();
    await ref.putFile(_image).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        imgRef.add({'url': value, 'username': "$username", 'time': myDateTime});
      });
    });
  }

  Future getGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 0)
      getImage();
    else if (index == 1)
      getGallery();
    else if (index == 2) {
      Navigator.pop(this.context);
    } else {
      uploadFile();
      Navigator.pop(this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a picture to upload',
          style: TextStyle(color: Colors.black, fontFamily: "Pacifico"),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(
                _image,
                height: 250,
                width: MediaQuery.of(context).size.width * 1,
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
              size: 30.0,
            ),
            title: Text('Camera'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.storage,
              size: 30.0,
            ),
            title: Text('Gallery'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.close,
              size: 30.0,
            ),
            title: Text('Close'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
              size: 30.0,
            ),
            title: Text('Done'),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
