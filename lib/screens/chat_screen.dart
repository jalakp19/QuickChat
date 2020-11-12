import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quick_chat/screens/login_screen.dart';
import 'package:quick_chat/screens/profile_screen.dart';
import 'package:quick_chat/services/auth.dart';
import 'package:quick_chat/services/crud.dart';
import 'find_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TabController tabController;

  bool spinner = false;
  AuthMethods authMethods = new AuthMethods();
  CRUDMethods crudMethods = new CRUDMethods();
  String userName = 'Loading...';

  Widget displayChats;

  @override
  void initState() {
    crudMethods.getDocId(FirebaseAuth.instance.currentUser.email).then((val) {
      setState(() {
        userName = val.docs.first['username'];
      });
    });

    displayChats = crudMethods.getAllChats();

    super.initState();
    tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          switch (tabController.index) {
            case 0:
              FocusScope.of(context).unfocus();
              break;
            case 1:
              break;
            case 2:
              FocusScope.of(context).unfocus();
              break;
          }
        });
      });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            title: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Quick Chat",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () async {
                  try {
                    await authMethods.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 16.0),
                  child: Icon(Icons.logout),
                ),
              ),
            ],
            backgroundColor: Color(0xFF128C7E),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home),
                      Text(" CHATS"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people),
                      Text(
                        " FIND",
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Text(
                        "PROFILE",
                      ),
                    ],
                  ),
                ),
              ],
              controller: tabController,
              indicatorColor: Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Scaffold(
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      tabController.animateTo(1);
                    });
                  },
                  child: Icon(
                    Icons.message,
                  ),
                  backgroundColor: Color(0xFF25D366)),
              body: Column(
                children: [
                  SizedBox(
                    height: 2.0,
                  ),
                  Container(
                    child: displayChats,
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  color: Color(0xFF128C7E),
                ),
                elevation: 0,
              ),
            ),
            FindScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
