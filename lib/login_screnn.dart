import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_wings/child/bottom_page.dart';
import 'package:safe_wings/componenets/PrimaryButton.dart';
import 'package:safe_wings/componenets/SecondaryButton.dart';
import 'package:safe_wings/componenets/custom_textfield.dart';
import 'package:safe_wings/db/share_pref.dart';
import 'package:safe_wings/parent/parent_home_sreen.dart';
import 'package:safe_wings/register_user.dart';
import 'package:safe_wings/utils/constants.dart';

import 'parent/parent _register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        progressIndicator(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _formData["email"].toString(),
                password: _formData["password"].toString());
        if(mounted) {
          setState(() {
            isLoading = false;
          });
        }
        if (userCredential.user != null) {
          setState(() {
            isLoading = false;
          });
          FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .get()
              .then((value){
            if (mounted) {
              print("====> ${value['type']}");
              if (value['type'] == 'parent') {
                MySharedPrefference.saveUserType('parent');
                goTo(context, ParentHomeScreen());
              } else {
                MySharedPrefference.saveUserType('child');
                goTo(context, BottomPage());
              }
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'user-not-found') {
          dialogueBox(context, 'No user found for that email.');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          dialogueBox(context, 'Wrong password provided for that user.');
          print('Wrong password provided for that user.');
        } else {
          dialogueBox(context, "Incorrect login credentials..");
        }
      }
    }
    print(_formData["email"]);
    print(_formData["password"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              children: [
                                Text(
                                  "USER LOGIN",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfffc3b77)),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Image.asset(
                                  "assets/images/logo.png",
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextField(
                                      hintText: "Enter Email",
                                      textInputAction: TextInputAction.next,
                                      keyboardtype: TextInputType.emailAddress,
                                      prefix: Icon(Icons.email),
                                      onsave: (email) {
                                        _formData["email"] = email ?? "";
                                      },
                                      validate: (email) {
                                        if (email!.isEmpty ||
                                            email.length < 3 ||
                                            !email.contains("@")) {
                                          return "Enter a valid email";
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: 30),
                                  CustomTextField(
                                    hintText: "Enter Password",
                                    isPassword: isPasswordShown,
                                    prefix: Icon(Icons.lock),
                                    onsave: (password) {
                                      _formData["password"] = password ?? "";
                                    },
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 7) {
                                        return "Enter a valid password";
                                      }
                                      return null;
                                    },
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordShown = !isPasswordShown;
                                        });
                                      },
                                      icon: isPasswordShown
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  PrimaryButtonn(
                                      title: "LOGIN",
                                      onPressed: () {
                                        progressIndicator(context);
                                        if (_formKey.currentState!.validate()) {
                                          _onSubmit();
                                        }
                                      }),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Forgot password?",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SecondaryButton(
                                    title: "Click here", onPressed: () {}),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SecondaryButton(
                              title: "Register as child",
                              onPressed: () {
                                goTo(context, RegisterUser());
                              }),
                          SecondaryButton(
                              title: "Register as Parent",
                              onPressed: () {
                                goTo(context, RegisterParentScreen());
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
