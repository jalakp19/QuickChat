import 'package:flutter/material.dart';
import 'package:quick_chat/services/crud.dart';

class UpdateUserName extends StatefulWidget {
  final String docId;
  UpdateUserName({this.docId});

  @override
  _UpdateUserNameState createState() => _UpdateUserNameState();
}

class _UpdateUserNameState extends State<UpdateUserName> {
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
              'Update Username',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                color: Color(0xFF128C7E),
                decoration: TextDecoration.underline,
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
                'Update',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Color(0xFF128C7E),
              onPressed: () {
                crudMethods.updateUserName(widget.docId, myController.text);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
