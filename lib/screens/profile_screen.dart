import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quick_chat/screens/update_username.dart';
import 'package:quick_chat/screens/update_about.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

import 'package:quick_chat/services/auth.dart';
import 'package:quick_chat/services/crud.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool spinner = false;

  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();

  String currentUserEmail = FirebaseAuth.instance.currentUser.email;
  String docId;

  Widget userNameDisplay;
  Widget aboutDisplay;
  Widget profilePicDisplay;

  File newProfilePic;
  Future getImage() async {
    var tempImg = await ImagePicker().getImage(source: ImageSource.gallery);
    newProfilePic = File(tempImg.path);
    setState(() {
      spinner = true;
    });
    uploadImage();
  }

  uploadImage() {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilepics/$docId.jpg');

    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    task.onComplete.then((value) async {
      print('##############done#########');
      var newPhotoUrl = await value.ref.getDownloadURL();
      String strVal = newPhotoUrl.toString();
      crudMethods.updateProfilePic(docId, strVal);
      setState(() {
        spinner = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget _circleAvatar() {
    return Stack(
      children: [
        profilePicDisplay,
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 3.45,
              top: MediaQuery.of(context).size.width / 3.45),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                getImage();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    userNameDisplay =
        crudMethods.getUserNameWid(FirebaseAuth.instance.currentUser.email);
    aboutDisplay =
        crudMethods.getAbout(FirebaseAuth.instance.currentUser.email);
    profilePicDisplay =
        crudMethods.getProfilePic(FirebaseAuth.instance.currentUser.email);

    crudMethods.getDocId(currentUserEmail).then((val) {
      docId = val.docs.first.id;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            // alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                FirebaseAuth.instance.currentUser.email,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
            color: Color(0xFF128C7E),
          ),
          elevation: 0,
        ),
        body: Container(
          child: Stack(
            // alignment: Alignment.center,
            children: [
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: HeaderCurvedContainer(),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    _circleAvatar(),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.0005,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Color(0xFF128C7E),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: userNameDisplay,
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(
                                    right: 10.0,
                                    left: 10.0,
                                  ),
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => UpdateUserName(
                                        docId: docId,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'About',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.0005,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Color(0xFF128C7E),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: aboutDisplay,
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(
                                    right: 10.0,
                                    left: 10.0,
                                  ),
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => UpdateAbout(
                                        docId: docId,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double heightt = size.height / 6;

    Paint paint = Paint()..color = const Color(0xFF128C7E);
    Path path = Path()
      ..relativeLineTo(0, heightt)
      ..quadraticBezierTo(size.width / 2, heightt * 2, size.width, heightt)
      ..relativeLineTo(0, -500)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
