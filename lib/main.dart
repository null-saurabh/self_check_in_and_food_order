import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/check_in_list_admin.dart';
import 'package:wandercrew/pages/admin/home_admin/admin_home_screen.dart';
import 'package:wandercrew/pages/admin/home_admin/widgets/add_food.dart';
import 'package:wandercrew/pages/admin/login_admin/admin_login.dart';
import 'package:wandercrew/pages/admin/orders_admin/orders_list_screen.dart';
import 'package:wandercrew/pages/client/cart_screen/cart_screen.dart';
import 'package:wandercrew/pages/client/menu_screen/menu_screen.dart';
import 'package:wandercrew/pages/client/reception_home_screen/reception_home_screen.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_screen.dart';
import 'package:wandercrew/pages/client/self_checking_screen/self_check_in_one_document_info.dart';
import 'package:wandercrew/service/auth_services.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/reception',
      getPages: [
        GetPage(
          name: '/reception',
          page: () => const ReceptionHomeScreen(),
        ),
        GetPage(
          name: '/reception/menu',
          page: () => const MenuScreen(),
        ),
        GetPage(
          name: '/reception/checkIn',
          page: () => const CheckInScreen(),
        ),
        GetPage(
          name: '/reception/menu/cart',
          page: () => const CartScreen(),
        ),
        GetPage(
          name: '/admin/login',
          page: () => const AdminLogin(),
        ),
        GetPage(
          name: '/admin',
          page: () => const AdminHomeScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/admin/add-menu',
          page: () => const AddFoodItem(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/admin/order-list',
          page: () => const OrdersListScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/admin/check-in-list',
          page: () => const CheckInListAdmin(),
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
