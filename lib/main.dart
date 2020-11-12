import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/screens/chat_room.dart';
import 'package:quick_chat/screens/chat_screen.dart';
import 'package:quick_chat/screens/login_screen.dart';
import 'package:quick_chat/screens/register.dart';
import 'package:firebase_core/firebase_core.dart';

User user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  user = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Chat',
      debugShowCheckedModeBanner: false,
      initialRoute: ((user == null || !user.emailVerified)
          ? LoginScreen.id
          : ChatScreen.id),
      // initialRoute: ChatRoom.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        Register.id: (context) => Register(),
        ChatScreen.id: (context) => ChatScreen(),
        ChatRoom.id: (context) => ChatRoom(),
      },
    );
  }
}
