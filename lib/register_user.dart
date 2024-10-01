import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_wings/componenets/PrimaryButton.dart';
import 'package:safe_wings/componenets/SecondaryButton.dart';
import 'package:safe_wings/componenets/custom_textfield.dart';
import 'package:safe_wings/login_screnn.dart';
import 'package:safe_wings/model/user_model.dart';
import 'utils/constants.dart';

class RegisterUser extends StatefulWidget {
  @override
  State<RegisterUser> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterUser> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      dialogueBox(context, 'password not matching..');
    } else {
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _formData['cemail'].toString(),
            password: _formData['password'].toString());
        if (userCredential.user != null) {
          setState(() {
            isLoading = true;
          });
          final v = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
          FirebaseFirestore.instance.collection('users').doc(v);

          final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['cemail'].toString(),
            guardianEmail: _formData['gemail'].toString(),
            id: v,
            type: 'child',
          );
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            goTo(context, LoginScreen());
            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          dialogueBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          dialogueBox(context, 'The account already exists for that email.');
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        dialogueBox(context, e.toString());
      }
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "REGISTER AS CHILD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffc3b77)),
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTextField(
                              hintText: 'enter name',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.name,
                              prefix: Icon(Icons.person),
                              onsave: (name) {
                                _formData['name'] = name ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty || email.length < 3) {
                                  return 'enter correct name';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'enter phone',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.phone,
                              prefix: Icon(Icons.phone),
                              onsave: (phone) {
                                _formData['phone'] = phone ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty || email.length < 10) {
                                  return 'enter correct phone';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'enter email',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.emailAddress,
                              prefix: Icon(Icons.email),
                              onsave: (email) {
                                _formData['cemail'] = email ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty ||
                                    email.length < 3 ||
                                    !email.contains("@")) {
                                  return 'enter correct email';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'enter guardian email',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.emailAddress,
                              prefix: Icon(Icons.email),
                              onsave: (gemail) {
                                _formData['gemail'] = gemail ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty ||
                                    email.length < 3 ||
                                    !email.contains("@")) {
                                  return 'enter correct email';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: 'enter password',
                              isPassword: isPasswordShown,
                              prefix: Icon(Icons.lock),
                              validate: (password) {
                                if (password!.isEmpty ||
                                    password.length < 7) {
                                  return 'enter correct password';
                                }
                                return null;
                              },
                              onsave: (password) {
                                _formData['password'] = password ?? "";
                              },
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordShown = !isPasswordShown;
                                    });
                                  },
                                  icon: isPasswordShown
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),
                            CustomTextField(
                              hintText: 'retype password',
                              isPassword: isRetypePasswordShown,
                              prefix: Icon(Icons.lock),
                              validate: (password) {
                                if (password!.isEmpty ||
                                    password.length < 7) {
                                  return 'enter correct password';
                                }
                                return null;
                              },
                              onsave: (password) {
                                _formData['rpassword'] = password ?? "";
                              },
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isRetypePasswordShown =
                                      !isRetypePasswordShown;
                                    });
                                  },
                                  icon: isRetypePasswordShown
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),
                            PrimaryButtonn(
                                title: 'REGISTER',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onSubmit();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    SecondaryButton(
                        title: 'Login with your account',
                        onPressed: () {
                          goTo(context, LoginScreen());
                        }),
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





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:safe_wings/componenets/PrimaryButton.dart';
// import 'package:safe_wings/componenets/SecondaryButton.dart';
// import 'package:safe_wings/componenets/custom_textfield.dart';
// import 'package:safe_wings/login_screnn.dart';
// import 'package:safe_wings/model/user_model.dart';
// import 'package:safe_wings/utils/constants.dart';
//
// class RegisterUser extends StatefulWidget {
//   @override
//   State<RegisterUser> createState() => _RegisterUserState();
// }
//
// class _RegisterUserState extends State<RegisterUser> {
//   bool isPasswordShown = true;
//
//   final _formKey = GlobalKey<FormState>();
//
//   final _formData = Map<String, Object>();
//
//   _onSubmit() {
//     _formKey.currentState!.save();
//     if (_formData["password"] != _formData["confirmPassword"]) {
//       dialogueBox(context, "Passwords is not matching..");
//     } else {
//       progressIndicator(context);
//       try {
//         FirebaseAuth auth = FirebaseAuth.instance;
//         auth
//             .createUserWithEmailAndPassword(
//                 email: _formData["email"].toString(),
//                 password: _formData["password"].toString())
//             .then((v) async {
//           DocumentReference<Map<String, dynamic>> db =
//               FirebaseFirestore.instance.collection("users").doc(v.user!.uid);
//           final user = UserModel(
//             name: _formData['name'].toString(),
//             phone: _formData['phone'].toString(),
//             childEmail: _formData['email'].toString(),
//             parentEmail: _formData['gemail'].toString(),
//             id: v.user!.uid,
//           );
//           final jsonData = user.toJson();
//           await db.set(jsonData).whenComplete((){
//
//           });
//           goTo(context, LoginScreen());
//         });
//       } on FirebaseAuthException catch (e) {
//         dialogueBox(context, e.toString());
//       } catch (e) {
//         dialogueBox(context, e.toString());
//       }
//     }
//     print(_formData["email"]);
//     print(_formData["password"]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   child: Column(
//                     children: [
//                       Text(
//                         "REGISTER AS CHILD",
//                         style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xfffc3b77)),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Image.asset(
//                         "assets/images/logo.png",
//                         height: 100,
//                         width: 100,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         CustomTextField(
//                             hintText: "Enter name",
//                             textInputAction: TextInputAction.next,
//                             keyboardtype: TextInputType.name,
//                             prefix: Icon(Icons.person),
//                             onsave: (name) {
//                               _formData["name"] = name ?? "";
//                             },
//                             validate: (name) {
//                               if (name!.isEmpty || name.length < 3) {
//                                 return "Enter a valid name";
//                               }
//                               return null;
//                             }),
//                         CustomTextField(
//                             hintText: "Enter phone",
//                             textInputAction: TextInputAction.next,
//                             keyboardtype: TextInputType.phone,
//                             prefix: Icon(Icons.phone),
//                             onsave: (phone) {
//                               _formData["phone"] = phone ?? "";
//                             },
//                             validate: (phone) {
//                               if (phone!.isEmpty || phone.length < 10) {
//                                 return "Enter a valid phone number";
//                               }
//                               return null;
//                             }),
//                         CustomTextField(
//                             hintText: "Enter Email",
//                             textInputAction: TextInputAction.next,
//                             keyboardtype: TextInputType.emailAddress,
//                             prefix: Icon(Icons.email),
//                             onsave: (email) {
//                               _formData["email"] = email ?? "";
//                             },
//                             validate: (email) {
//                               if (email!.isEmpty ||
//                                   email.length < 3 ||
//                                   !email.contains("@")) {
//                                 return "Enter a valid email";
//                               }
//                               return null;
//                             }),
//                         CustomTextField(
//                             hintText: "Enter Guardian Email",
//                             textInputAction: TextInputAction.next,
//                             keyboardtype: TextInputType.emailAddress,
//                             prefix: Icon(Icons.email),
//                             onsave: (gemail) {
//                               _formData["gemail"] = gemail ?? "";
//                             },
//                             validate: (gemail) {
//                               if (gemail!.isEmpty ||
//                                   gemail.length < 3 ||
//                                   !gemail.contains("@")) {
//                                 return "Enter a valid email";
//                               }
//                               return null;
//                             }),
//                         CustomTextField(
//                           hintText: "Enter password",
//                           isPassword: isPasswordShown,
//                           prefix: Icon(Icons.lock),
//                           onsave: (password) {
//                             _formData["password"] = password ?? "";
//                           },
//                           validate: (password) {
//                             if (password!.isEmpty || password.length < 7) {
//                               return "Enter a valid password";
//                             }
//                             return null;
//                           },
//                           suffix: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isPasswordShown = !isPasswordShown;
//                                 });
//                               },
//                               icon: isPasswordShown
//                                   ? Icon(Icons.visibility_off)
//                                   : Icon(Icons.visibility)),
//                         ),
//                         CustomTextField(
//                           hintText: "Re-type password",
//                           isPassword: isPasswordShown,
//                           prefix: Icon(Icons.lock),
//                           onsave: (password) {
//                             _formData["confirmPassword"] = password ?? "";
//                           },
//                           validate: (password) {
//                             if (password!.isEmpty || password.length < 7) {
//                               return "Enter a valid password";
//                             }
//                             return null;
//                           },
//                           suffix: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isPasswordShown = !isPasswordShown;
//                                 });
//                               },
//                               icon: isPasswordShown
//                                   ? Icon(Icons.visibility_off)
//                                   : Icon(Icons.visibility)),
//                         ),
//                         PrimaryButtonn(
//                             title: "REGISTER",
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 _onSubmit();
//                               }
//                             }),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SecondaryButton(
//                     title: "Login with your account",
//                     onPressed: () {
//                       goTo(context, LoginScreen());
//                     }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
