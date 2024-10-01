import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_wings/componenets/PrimaryButton.dart';
import 'package:safe_wings/componenets/custom_textfield.dart';
import 'package:safe_wings/login_screnn.dart';
import 'package:safe_wings/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
  const CheckUserStatusBeforeChatOnProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return progressIndicator(context);
        } else {
          if (snapshot.hasData) {
            return ProfilePage();
          } else {
            Fluttertoast.showToast(msg: 'please login first');
            return LoginScreen();
          }
        }
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController guardianEmailC = TextEditingController();
  TextEditingController childEmailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameC.text = value.docs.first['name'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(onPressed: () async{
            try { var pref = await SharedPreferences.getInstance();
              await FirebaseAuth.instance.signOut();
              await pref.clear();
              goTo(context, LoginScreen());
            } on FirebaseAuthException catch (e) {
              dialogueBox(context, e.toString());
            }

          }, icon: Icon(Icons.logout))
      ),
      body: isSaving == true
          ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.pink,
          ))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "UPDATE YOUR PROFILE",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => showProfilePicOptions(context),
                        child: Container(
                          child: profilePic == null
                              ? CircleAvatar(
                            backgroundColor: Colors.pink[200],
                            radius: 75,
                            child: Center(
                                child: Image.asset(
                                  'assets/images/add_profile.png',
                                  height: 100,
                                )),
                          )
                              : profilePic!.contains('http')
                              ? CircleAvatar(
                            backgroundColor: Colors.pink[200],
                            radius: 80,
                            backgroundImage:
                            NetworkImage(profilePic!),
                          )
                              : CircleAvatar(
                              backgroundColor: Colors.pink[200],
                              radius: 80,
                              backgroundImage:
                              FileImage(File(profilePic!))),
                        ),
                      ),
                      SizedBox(height: 20,),
                      CustomTextField(
                        controller: nameC,
                        hintText: nameC.text,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return 'please enter your updated name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25),
                      PrimaryButtonn(
                          title: "UPDATE",
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              profilePic == null
                                  ? Fluttertoast.showToast(
                                  msg: 'please select profile picture')
                                  : update();
                            }
                          })
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final filenName = Uuid().v4();
      final Reference fbStorage =
      FirebaseStorage.instance.ref('profile').child(filenName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  update() async {
    setState(() {
      isSaving = true;
    });

    if (!profilePic!.contains('http')) {
      // Only upload the image if it's not already a URL
      await uploadImage(profilePic!).then((value) {
        if (value != null) {
          downloadUrl = value;
        }
      });
    } else {
      downloadUrl = profilePic;
    }

    if (downloadUrl != null) {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'profilePic': downloadUrl,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
      Fluttertoast.showToast(msg: 'PROFILE UPDATED');
    }

    setState(() {
      isSaving = false;
    });
  }


  void showProfilePicOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? pickImage = await ImagePicker().pickImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (pickImage != null) {
                      setState(() {
                        profilePic = pickImage.path;
                      });
                    }
                  }),
              profilePic != null
                  ? ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remove'),
                onTap: () {
                  Navigator.of(context).pop();
                  removeProfilePic();
                },
              )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  void removeProfilePic() {
    setState(() {
      profilePic = null;
    });
  }
}





// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:safe_wings/componenets/PrimaryButton.dart';
// import 'package:safe_wings/componenets/custom_textfield.dart';
// import 'package:safe_wings/login_screnn.dart';
// import 'package:safe_wings/utils/constants.dart';
// import 'package:uuid/uuid.dart';
//
//
// class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
//   const CheckUserStatusBeforeChatOnProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return progressIndicator(context);
//         } else {
//           if (snapshot.hasData) {
//             return ProfilePage();
//           } else {
//             Fluttertoast.showToast(msg: 'please login first');
//             return LoginScreen();
//           }
//         }
//       },
//     );
//   }
// }
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   TextEditingController nameC = TextEditingController();
//   TextEditingController guardianEmailC = TextEditingController();
//   TextEditingController childEmailC = TextEditingController();
//   TextEditingController phoneC = TextEditingController();
//
//   final key = GlobalKey<FormState>();
//   String? id;
//   String? profilePic;
//   String? downloadUrl;
//   bool isSaving = false;
//   getDate() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((value) {
//       setState(() {
//         nameC.text = value.docs.first['name'];
//         id = value.docs.first.id;
//         profilePic = value.docs.first['profilePic'];
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getDate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: () async{
//           try {
//             await FirebaseAuth.instance.signOut();
//             goTo(context, LoginScreen());
//           } on FirebaseAuthException catch (e) {
//             dialogueBox(context, e.toString());
//           }
//
//         }, icon: Icon(Icons.logout))
//       ),
//       body: isSaving == true
//           ? Center(
//           child: CircularProgressIndicator(
//             backgroundColor: Colors.pink,
//           ))
//           : SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Center(
//             child: Form(
//                 key: key,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         "UPDATE YOUR PROFILE",
//                         style: TextStyle(fontSize: 25),
//                       ),
//                       SizedBox(height: 15),
//                       GestureDetector(
//                         onTap: () async {
//                           final XFile? pickImage = await ImagePicker()
//                               .pickImage(
//                               source: ImageSource.gallery,
//                               imageQuality: 50);
//                           if (pickImage != null) {
//                             setState(() {
//                               profilePic = pickImage.path;
//                             });
//                           }
//                         },
//                         child: Container(
//                           child: profilePic == null
//                               ? CircleAvatar(
//                             backgroundColor: Colors.pink[200],
//                             radius: 75,
//                             child: Center(
//                                 child: Image.asset(
//                                   'assets/images/add_profile.png',
//                                   height: 100,
//                                 )),
//                           )
//                               : profilePic!.contains('http')
//                               ? CircleAvatar(
//                             backgroundColor: Colors.pink[200],
//                             radius: 80,
//                             backgroundImage:
//                             NetworkImage(profilePic!),
//                           )
//                               : CircleAvatar(
//                               backgroundColor: Colors.pink[200],
//                               radius: 80,
//                               backgroundImage:
//                               FileImage(File(profilePic!))),
//                         ),
//                       ),
//                       SizedBox(height: 20,),
//                       CustomTextField(
//                         controller: nameC,
//                         hintText: nameC.text,
//                         validate: (v) {
//                           if (v!.isEmpty) {
//                             return 'please enter your updated name';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 25),
//                       PrimaryButtonn(
//                           title: "UPDATE",
//                           onPressed: () async {
//                             if (key.currentState!.validate()) {
//                               SystemChannels.textInput
//                                   .invokeMethod('TextInput.hide');
//                               profilePic == null
//                                   ? Fluttertoast.showToast(
//                                   msg: 'please select profile picture')
//                                   : update();
//                             }
//                           })
//                     ],
//                   ),
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<String?> uploadImage(String filePath) async {
//     try {
//       final filenName = Uuid().v4();
//       final Reference fbStorage =
//       FirebaseStorage.instance.ref('profile').child(filenName);
//       final UploadTask uploadTask = fbStorage.putFile(File(filePath));
//       await uploadTask.then((p0) async {
//         downloadUrl = await fbStorage.getDownloadURL();
//       });
//       return downloadUrl;
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//     return null;
//   }
//
//   update() async {
//     setState(() {
//       isSaving = true;
//     });
//     uploadImage(profilePic!).then((value) {
//       Map<String, dynamic> data = {
//         'name': nameC.text,
//         'profilePic': downloadUrl,
//       };
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update(data);
//       setState(() {
//         isSaving = false;
//       });
//     });
//   }
// }
//
