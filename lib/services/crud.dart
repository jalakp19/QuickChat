import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/screens/chat_room.dart';
import 'package:intl/intl.dart';

class CRUDMethods {
  String defaultImage =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  String defaultStatus = 'Hey there! I\'m using QuickChat';
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String username, String email) {
    return users
        .add({
          'username': username,
          'email': email,
          'profile_pic': defaultImage,
          'about': defaultStatus,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  getDocId(String email) async {
    return await users.where('email', isEqualTo: email).get();
  }

  getProfilePic(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.where('email', isEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(defaultImage),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(defaultImage),
                ),
              ),
            );
          }

          return Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.width / 2.5,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(snapshot.data.docs.first['profile_pic']),
              ),
            ),
          );
        },
      ),
    );
  }

  getAbout(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.where('email', isEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Text(
            snapshot.data.docs.first['about'],
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteMessage(String chatId, String docId) {
    CollectionReference msg = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatId)
        .collection('messages');

    return msg
        .doc(docId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> updateUserName(String docId, String val) async {
    return users
        .doc(docId)
        .update({'username': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateAbout(String docId, String val) async {
    return users
        .doc(docId)
        .update({'about': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateProfilePic(String docId, String val) async {
    return users
        .doc(docId)
        .update({'profile_pic': val})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  getUserNameWid(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.where('email', isEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Text(
            snapshot.data.docs.first['username'],
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  getAllUsers() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.orderBy('username').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView.builder(
            itemCount: snapshot.data.size,
            itemBuilder: (context, i) {
              if (FirebaseAuth.instance.currentUser.email !=
                  snapshot.data.docs[i]['email']) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        String key = getChatRoomId(
                            FirebaseAuth.instance.currentUser.email,
                            snapshot.data.docs[i]['email']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              docId: key,
                              senderEmail:
                                  FirebaseAuth.instance.currentUser.email,
                              receiverEmail: snapshot.data.docs[i]['email'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  snapshot.data.docs[i]['profile_pic']),
                            ),
                          ),
                        ),
                        title: new Text(snapshot.data.docs[i]['username']),
                        subtitle: new Text(snapshot.data.docs[i]['email']),
                      ),
                    ),
                    Divider(
                      color: Colors.black54,
                      height: 0.0,
                      indent: 50.0,
                      endIndent: 50.0,
                      thickness: 0.0,
                    )
                  ],
                );
              } else {
                return SizedBox(
                  height: 0.0,
                );
              }
            },
          );
        },
      ),
    );
  }

  getAllUsersWithSearch(String val) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.orderBy('username').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Text("Loading");
          }

          return new ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (context, i) {
                if (FirebaseAuth.instance.currentUser.email !=
                    snapshot.data.docs[i]['email']) {
                  if (snapshot.data.docs[i]['username'].startsWith(val)) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            String key = getChatRoomId(
                                FirebaseAuth.instance.currentUser.email,
                                snapshot.data.docs[i]['email']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  docId: key,
                                  senderEmail:
                                      FirebaseAuth.instance.currentUser.email,
                                  receiverEmail: snapshot.data.docs[i]['email'],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Container(
                              width: 50.0,
                              height: 50.0,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      snapshot.data.docs[i]['profile_pic']),
                                ),
                              ),
                            ),
                            title: new Text(snapshot.data.docs[i]['username']),
                            subtitle: new Text(snapshot.data.docs[i]['email']),
                          ),
                        ),
                        Divider(
                          color: Colors.black54,
                          height: 0.0,
                          indent: 50.0,
                          endIndent: 50.0,
                          thickness: 0.0,
                        )
                      ],
                    );
                  } else {
                    return SizedBox(
                      height: 0.0,
                    );
                  }
                } else {
                  return SizedBox(
                    height: 0.0,
                  );
                }
              });
        },
      ),
    );
  }

  getAllChats() {
    CollectionReference chatRooms =
        FirebaseFirestore.instance.collection('chatrooms');

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: chatRooms.orderBy('time', descending: true).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> mainsnapshot) {
          Widget response;

          if (mainsnapshot.hasError) {
            response = Text('Something went wrong');
          }

          if (mainsnapshot.connectionState == ConnectionState.waiting) {
            response = CircularProgressIndicator();
          }

          if (mainsnapshot.connectionState == ConnectionState.active) {
            response = ListView.builder(
              itemCount: mainsnapshot.data.size,
              itemBuilder: (context, i) {
                String receiverEmailId =
                    FirebaseAuth.instance.currentUser.email ==
                            mainsnapshot.data.docs[i]['usera']
                        ? mainsnapshot.data.docs[i]['userb']
                        : mainsnapshot.data.docs[i]['usera'];

                String receiverUserName =
                    FirebaseAuth.instance.currentUser.email ==
                            mainsnapshot.data.docs[i]['usera']
                        ? mainsnapshot.data.docs[i]['userb_username']
                        : mainsnapshot.data.docs[i]['usera_username'];

                String receiverDisplayPic =
                    FirebaseAuth.instance.currentUser.email ==
                            mainsnapshot.data.docs[i]['usera']
                        ? mainsnapshot.data.docs[i]['userb_dp']
                        : mainsnapshot.data.docs[i]['usera_dp'];

                final messageTime =
                    mainsnapshot.data.docs[i]['time'] as Timestamp;
                String time = 'Loading...';
                time =
                    DateFormat('dd/MM/yy : kk:mm').format(messageTime.toDate());

                if ((FirebaseAuth.instance.currentUser.email ==
                        mainsnapshot.data.docs[i]['usera']) ||
                    (FirebaseAuth.instance.currentUser.email ==
                        mainsnapshot.data.docs[i]['userb'])) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          String key = getChatRoomId(
                              mainsnapshot.data.docs[i]['usera'],
                              mainsnapshot.data.docs[i]['userb']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                docId: key,
                                senderEmail:
                                    FirebaseAuth.instance.currentUser.email,
                                receiverEmail: receiverEmailId,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Container(
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(receiverDisplayPic),
                              ),
                            ),
                          ),
                          title: new Text(receiverUserName),
                          subtitle: new Text(time),
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                        height: 0.0,
                        indent: 50.0,
                        endIndent: 50.0,
                        thickness: 0.0,
                      )
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 0.0,
                  );
                }
              },
            );
          }

          return response;
        },
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.compareTo(b) == 1) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }
}

// getAllChats() {
//   CollectionReference chatRooms =
//   FirebaseFirestore.instance.collection('chatrooms');
//
//   return Flexible(
//     child: StreamBuilder<QuerySnapshot>(
//       stream: chatRooms.orderBy('time', descending: true).snapshots(),
//       builder:
//           (BuildContext context, AsyncSnapshot<QuerySnapshot> mainsnapshot) {
//         Widget response;
//
//         if (mainsnapshot.hasError) {
//           response = Text('Something went wrong');
//         }
//
//         if (mainsnapshot.connectionState == ConnectionState.waiting) {
//           response = CircularProgressIndicator();
//         }
//
//         String displayPic = defaultImage;
//         String userName = 'Loading...';
//
//         if (mainsnapshot.connectionState == ConnectionState.active) {
//           response = ListView.builder(
//             itemCount: mainsnapshot.data.size,
//             itemBuilder: (context, i) {
//               String receiverEmailId =
//               FirebaseAuth.instance.currentUser.email ==
//                   mainsnapshot.data.docs[i]['usera']
//                   ? mainsnapshot.data.docs[i]['userb']
//                   : mainsnapshot.data.docs[i]['usera'];
//
//               _fetchReceiverDetails(String email) async {
//                 final messageTime =
//                 mainsnapshot.data.docs[i]['time'] as Timestamp;
//
//                 await users
//                     .where('email', isEqualTo: email)
//                     .get()
//                     .then((val) {
//                   displayPic = val.docs.first['profile_pic'];
//                   userName = val.docs.first['username'];
//                 });
//                 String time = 'Loading...';
//                 time = DateFormat('dd/MM/yy : kk:mm')
//                     .format(messageTime.toDate());
//
//                 return {
//                   'displayPIC': displayPic,
//                   'userName': userName,
//                   'time': time,
//                 };
//               }
//
//               return FutureBuilder(
//                   future: _fetchReceiverDetails(receiverEmailId),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<Map<String, dynamic>> snapshot) {
//                     if (snapshot.connectionState == ConnectionState.none ||
//                         snapshot.connectionState == ConnectionState.waiting) {
//                       // return Align(
//                       //   alignment: Alignment.center,
//                       //   child: CircularProgressIndicator(),
//                       // );
//                       return Container();
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.done &&
//                         snapshot.hasError) {
//                       return Text(
//                           'Something went wrong. Please try again...');
//                     }
//
//                     var info = snapshot.data;
//                     if ((FirebaseAuth.instance.currentUser.email ==
//                         mainsnapshot.data.docs[i]['usera']) ||
//                         (FirebaseAuth.instance.currentUser.email ==
//                             mainsnapshot.data.docs[i]['userb'])) {
//                       return Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               String key = getChatRoomId(
//                                   mainsnapshot.data.docs[i]['usera'],
//                                   mainsnapshot.data.docs[i]['userb']);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ChatRoom(
//                                     docId: key,
//                                     senderEmail: FirebaseAuth
//                                         .instance.currentUser.email,
//                                     receiverEmail: receiverEmailId,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: ListTile(
//                               leading: Container(
//                                 width: 50.0,
//                                 height: 50.0,
//                                 padding: EdgeInsets.all(5.0),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                   image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: NetworkImage(info['displayPIC']),
//                                   ),
//                                 ),
//                               ),
//                               title: new Text(info['userName']),
//                               subtitle: new Text(info['time']),
//                             ),
//                           ),
//                           Divider(
//                             color: Colors.black54,
//                             height: 0.0,
//                             indent: 50.0,
//                             endIndent: 50.0,
//                             thickness: 0.0,
//                           )
//                         ],
//                       );
//                     } else {
//                       return SizedBox(
//                         height: 0.0,
//                       );
//                     }
//                   });
//             },
//           );
//         }
//
//         return response;
//       },
//     ),
//   );
// }
