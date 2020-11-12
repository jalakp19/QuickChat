import 'package:flutter/material.dart';
import 'package:quick_chat/services/crud.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  var focusNode = new FocusNode();
  CRUDMethods crudMethods = new CRUDMethods();
  TextEditingController myController = new TextEditingController();

  Widget allUsers;
  fetchUsers(String val) {
    if (val == '' || val == null) {
      setState(() {
        allUsers = crudMethods.getAllUsers();
      });
    } else {
      setState(() {
        allUsers = crudMethods.getAllUsersWithSearch(val);
      });
    }
  }

  @override
  void initState() {
    fetchUsers('');
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(focusNode);
          },
          child: Icon(
            Icons.search,
          ),
          backgroundColor: Color(0xFF25D366)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: myController,
              focusNode: focusNode,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'Start a new conversation...',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 25.0, top: 20.0, bottom: 10.0)),
              onChanged: (val) {
                fetchUsers(myController.text);
              },
            ),
          ),
          Container(
            child: allUsers,
          ),
        ],
      ),
    );
  }
}
