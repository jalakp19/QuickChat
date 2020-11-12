import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/services/crud.dart';

import 'chat_screen.dart';

class VerifyEmail extends StatefulWidget {
  final String docId;
  VerifyEmail({this.docId});

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController myController = TextEditingController();

  CRUDMethods crudMethods = new CRUDMethods();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      // color: Colors.,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Verify your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Please enter the verification code sent to your email...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            TextField(
              autofocus: true,
              cursorColor: Colors.black,
              controller: myController,
              textAlign: TextAlign.center,
            ),
            FlatButton(
              child: Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.blueAccent,
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                String code = myController.text;

                try {
                  await auth.checkActionCode(code);
                  await auth.applyActionCode(code);

                  auth.currentUser.reload();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-action-code') {
                    print('The code is invalid.');
                    Navigator.pop(context, true);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
