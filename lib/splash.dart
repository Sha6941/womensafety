import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safe_wings/login_screnn.dart';
import 'package:safe_wings/utils/constants.dart';

class Splashh extends StatefulWidget {
  const Splashh({super.key});

  @override

  State<Splashh> createState() => _SplashhState();
}

class _SplashhState extends State<Splashh> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), () {
      goTo(context, LoginScreen());
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset("assets/images/she safe logo.png",scale: 5,),
                Text("SAFE WINGS",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.pink[900]),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
