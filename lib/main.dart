import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wandercrew/service/auth_services.dart';
import 'package:wandercrew/utils/notification_handler.dart';
import 'package:wandercrew/utils/routes.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCeEq4VVlDp8plMO3LSGkQhHtxiEg4ONTg",
          appId: "1:383803428115:web:1432274364075cdb1a9ee6",
          messagingSenderId: "383803428115",
          authDomain: "wander-crew.firebaseapp.com",
          storageBucket: "wander-crew.appspot.com",
          projectId: "wander-crew",
          measurementId: "G-SCNPB2JYB5",
      ));

  NotificationHandler.initialize();

  Get.put(AuthService());
  setUrlStrategy(PathUrlStrategy());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wander Crew',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: router,
    );
  }



  ThemeData _buildTheme() {
    var baseTheme = ThemeData(
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      // fontFamily: 'Poppins',
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}




