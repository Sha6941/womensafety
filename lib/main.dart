import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_wings/child/bottom_page.dart';
import 'package:safe_wings/db/share_pref.dart';
import 'package:safe_wings/firebase_options.dart';
import 'package:safe_wings/parent/parent_home_sreen.dart';
import 'package:safe_wings/splash.dart';
import 'package:safe_wings/utils/constants.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MySharedPrefference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.firaSansTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
        ),
        home:
    FutureBuilder(
          future: MySharedPrefference.getUserType(),

          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data==""){
              return Splashh();
            }
            if(snapshot.data=="child"){
              return BottomPage();
            }
            if(snapshot.data=='parent'){
              return ParentHomeScreen();
            }

            return progressIndicator(context);
          },


    )
    );
  }
}
