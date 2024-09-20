import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/home_admin/home_admin.dart';
import 'package:wandercrew/pages/admin/home_admin/widgets/add_food.dart';
import 'package:wandercrew/pages/admin/login_admin/admin_login.dart';
import 'package:wandercrew/pages/cart_screen/cart_screen.dart';
import 'package:wandercrew/service/auth_services.dart';
import 'package:wandercrew/widgets/bottom_nav.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wander Crew',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const BottomNav(),
        ),
        GetPage(
          name: '/admin-login',
          page: () => const AdminLogin(),
        ),
        GetPage(
          name: '/cart',
          page: () => const CartScreen(),
        ),
        GetPage(
          name: '/admin/home',
          page: () => const HomeAdmin(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/admin/add-menu',
          page: () => const AddFoodItem(),
          middlewares: [AuthMiddleware()],
        ),
      ],
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
}


class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Store the original route the user tried to access
    // bool isLoggedIn = false;  // Replace this with actual authentication logic

    // final AuthService authService = AuthService();

    final AuthService authService = AuthService.to;
    // print("e");
    // print( route ?? "");
    // print(authService.isLoggedIn.value);

    if (!authService.isLoggedIn.value) {
      // print("ee");

      return RouteSettings(
        name: '/admin-login',
        arguments: {
          'redirect': route,  // Pass the route where the user was trying to go
        },); // Pass the original route as an argument
    }
    return null; // Allow access if logged in
  }
}
