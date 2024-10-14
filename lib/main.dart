import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wandercrew/service/auth_services.dart';
import 'package:wandercrew/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCeEq4VVlDp8plMO3LSGkQhHtxiEg4ONTg",
          appId: "1:383803428115:web:1432274364075cdb1a9ee6",
          messagingSenderId: "383803428115",
          storageBucket: "wander-crew.appspot.com",
          projectId: "wander-crew"));
  Get.put(AuthService());
  setUrlStrategy(PathUrlStrategy());
  // registerImageViewFactory('https://firebasestorage.googleapis.com/v0/b/wander-crew.appspot.com/o/foodImages%2FScreenshot%20(1).png?alt=media&token=ce3dcce1-0732-48b3-ba5b-bb9cbcece69c');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wander Crew',
      debugShowCheckedModeBanner: false,
      theme:  _buildTheme(),
      initialRoute: Routes.receptionHome, // Use routes from routes.dart
      getPages: AppPages.pages,       // Use pages from app_pages.dart
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      ),

      // home: const BottomNav(),
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




