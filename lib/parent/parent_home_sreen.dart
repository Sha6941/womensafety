import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_wings/chat_module/chat_screen.dart';
import 'package:safe_wings/login_screnn.dart';
import 'package:safe_wings/utils/constants.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // If the user is not logged in, navigate to the login screen.
      Future.microtask(() => goTo(context, LoginScreen()));
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            bool confirmLogout = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure Do you want to log out?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false); // Return false
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return true
                      },
                    ),
                  ],
                );
              },
            );

            if (confirmLogout) {
              try {
                await FirebaseAuth.instance.signOut();
                goTo(context, LoginScreen());
              } on FirebaseAuthException catch (e) {
                dialogueBox(context, e.toString());
              }
            }
          },
          icon: Icon(Icons.logout, color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        title: Text("SELECT CHILD"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'child')
            .where('guardianEmail', isEqualTo: currentUser.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final d = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color.fromARGB(255, 250, 163, 192),
                  child: ListTile(
                    onTap: () {
                      goTo(
                        context,
                        ChatScreen(
                          currentUserId: currentUser.uid,
                          friendId: d.id,
                          friendName: d['name'],
                        ),
                      );
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(d['name']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:safe_wings/chat_module/chat_screen.dart';
// import 'package:safe_wings/login_screnn.dart';
// import 'package:safe_wings/utils/constants.dart';
//
// class ParentHomeScreen extends StatelessWidget {
//   const ParentHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: () async{
//             try {
//               await FirebaseAuth.instance.signOut();
//               goTo(context, LoginScreen());
//             } on FirebaseAuthException catch (e) {
//               dialogueBox(context, e.toString());
//             }
//
//           }, icon: Icon(Icons.logout,color: Colors.white,))
//         ],
//         backgroundColor: Colors.pink,
//         // backgroundColor: Color.fromARGB(255, 250, 163, 192),
//         title: Text("SELECT CHILD"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('type', isEqualTo: 'child')
//             .where('guardianEmail',
//             isEqualTo: FirebaseAuth.instance.currentUser!.email)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: progressIndicator(context));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               final d = snapshot.data!.docs[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   color: Color.fromARGB(255, 250, 163, 192),
//                   child: ListTile(
//                     onTap: () {
//                       goTo(
//                           context,
//                           ChatScreen(
//                               currentUserId:
//                               FirebaseAuth.instance.currentUser!.uid,
//                               friendId: d.id,
//                               friendName: d['name']));
//                     },
//                     title: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(d['name']),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
