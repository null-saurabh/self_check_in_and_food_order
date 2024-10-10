import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/check_in_list_admin.dart';
import 'package:wandercrew/pages/admin/home_admin/admin_home_screen.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';
import 'package:wandercrew/pages/admin/login_admin/admin_login.dart';
import 'package:wandercrew/pages/admin/menu_admin/menu_admin_screen.dart';
import 'package:wandercrew/pages/admin/orders_admin/orders_list_screen.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/manage_voucher_admin.dart';
import 'package:wandercrew/pages/client/cart_screen/cart_screen.dart';
import 'package:wandercrew/pages/client/menu_screen/menu_screen.dart';
import 'package:wandercrew/pages/client/reception_home_screen/reception_home_screen.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_screen.dart';
import 'package:wandercrew/service/auth_services.dart';

import '../pages/admin/users_admin/manage_user_admin.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.receptionHome,
      page: () => const ReceptionHomeScreen(),
    ),
    GetPage(
      name: Routes.receptionMenu,
      page: () => const MenuScreen(),
    ),
    GetPage(
      name: Routes.receptionCheckIn,
      page: () => const CheckInScreen(),
    ),
    GetPage(
      name: Routes.receptionCart,
      page: () => const CartScreen(),
    ),

    GetPage(
      name: Routes.adminLogin,
      page: () => const AdminLogin(),
    ),
    GetPage(
      name: Routes.adminHome,
      page: () => const AdminHomeScreen(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminMenu,
      page: () => const MenuAdminScreen(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminAddMenu,
      page: () => const AddFoodItem(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminOrderList,
      page: () => const OrdersListScreen(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminCheckInList,
      page: () => const CheckInListAdmin(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminManageUsers,
      page: () => const ManageUserAdmin(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminManageVoucher,
      page: () => const ManageVoucherAdmin(),
      // middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.notFound,
      page: () => const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    ),
  ];
}

class Routes {
  static const String receptionHome = '/reception';
  static const String receptionMenu = '/reception/menu';
  static const String receptionCheckIn = '/reception/checkIn';
  static const String receptionCart = '/reception/menu/cart';

  static const String adminLogin = '/admin/login';
  static const String adminHome = '/admin';
  static const String adminMenu = '/admin/menu';
  static const String adminAddMenu = '/admin/add-menu';
  static const String adminOrderList = '/admin/order-list';
  static const String adminCheckInList = '/admin/check-in-list';
  static const String adminManageUsers = '/admin/manage-user';
  static const String adminManageVoucher = '/admin/manage-voucher';

  static const String notFound = '/not-found';
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
        name: '/admin/login',
        arguments: {
          'redirect': route,  // Pass the route where the user was trying to go
        },); // Pass the original route as an argument
    }
    return null; // Allow access if logged in
  }
}
