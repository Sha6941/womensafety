import 'package:flutter/material.dart';
import 'package:safe_wings/child/bottom_screens/Review_page.dart';
import 'package:safe_wings/child/bottom_screens/add_contacts.dart';
import 'package:safe_wings/child/bottom_screens/chat_page.dart';
import 'package:safe_wings/child/bottom_screens/profile_page.dart';
import 'package:safe_wings/homescreen.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactsPage(),
    ChatPage(),
    ProfilePage(),
    ReviewPage()
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 8,bottom: 3,right: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 30,
              offset: Offset(0,20)
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            selectedItemColor: Color.fromARGB(255, 237, 19, 95),
            unselectedItemColor: Colors.black,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,

            onTap: onTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contacts,
                  ),
                  label: "Contacts"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_sharp,
                  ),
                  label: "Chats"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.reviews_outlined,
                  ),
                  label: "Reviews"),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:safe_wings/child/bottom_screens/Review_page.dart';
// import 'package:safe_wings/child/bottom_screens/add_contacts.dart';
// import 'package:safe_wings/child/bottom_screens/chat_page.dart';
// import 'package:safe_wings/child/bottom_screens/profile_page.dart';
// import 'package:safe_wings/homescreen.dart';
//
// class BottomPage extends StatefulWidget {
//   const BottomPage({super.key});
//
//   @override
//   State<BottomPage> createState() => _BottomPageState();
// }
//
// class _BottomPageState extends State<BottomPage> {
//   int currentIndex = 0;
//   List<Widget> pages = [
//     HomeScreen(),
//     AddContactsPage(),
//     ChatPage(),
//     ProfilePage(),
//     ReviewPage()
//   ];
//
//   onTapped(int index) {
//     if (mounted) {
//       setState(() {
//         currentIndex = index;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose of any controllers or resources here
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         type: BottomNavigationBarType.fixed,
//         onTap: onTapped,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contacts"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat_sharp), label: "Chats"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//           BottomNavigationBarItem(icon: Icon(Icons.reviews_outlined), label: "Reviews"),
//         ],
//       ),
//     );
//   }
// }
