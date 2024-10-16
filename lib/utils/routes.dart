import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:wandercrew/pages/client/track_order_screen/track_order_screen.dart';
import 'package:wandercrew/service/auth_services.dart';

import '../pages/admin/users_admin/manage_user_admin.dart';






final GoRouter router = GoRouter(
  initialLocation: Routes.receptionHome,
  routes: [
    GoRoute(
      path: Routes.receptionHome,
      name: 'ReceptionHome',
      builder: (context, state) => const ReceptionHomeScreen(),
    ),
    GoRoute(
      path: Routes.receptionMenu,
      name: 'ReceptionMenu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: Routes.receptionMenuCart,
      name: 'ReceptionMenuCart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: Routes.receptionCheckIn,
      name: 'ReceptionCheckIn',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: Routes.receptionTrackOrder,
      name: 'ReceptionTrackOrder',
      builder: (context, state) => const TrackOrderScreen(),
    ),
    GoRoute(
      path: Routes.adminLogin,
      name: 'AdminLogin',
      builder: (context, state) => const AdminLogin(),
    ),
    GoRoute(
      path: Routes.adminHome,
      name: 'AdminHome',
      builder: (context, state) => const AdminHomeScreen(),
      redirect: (context, state) => _authGuard(state),
    ),
    GoRoute(
      path: Routes.adminMenu,
      name: 'AdminMenu',
      builder: (context, state) => const MenuAdminScreen(),
      redirect: (context, state) => _authGuard(state),
    ),
    GoRoute(
      path: Routes.adminAddMenu,
      name: 'AdminAddMenu',
      builder: (context, state) => const AddFoodItem(),
      redirect: (context, state) => _authGuard(state),
    ),
    GoRoute(
      path: Routes.adminOrderList,
      name: 'AdminOrderList',
      builder: (context, state) => const OrdersListScreen(),
      redirect: (context, state) => _authGuard(state),
    ),
    GoRoute(
      path: Routes.adminCheckInList,
      name: 'AdminCheckInList',
      builder: (context, state) => const CheckInListAdmin(),
      redirect: (context, state) => _authGuard(state),
    ),
    GoRoute(
      path: Routes.adminManageUsers,
      name: 'AdminManageUsers',
      builder: (context, state) => const ManageUserAdmin(),
      redirect: (context, state) => _authGuard(state),
    ),
    GoRoute(
      path: Routes.adminManageVoucher,
      name: 'AdminManageVoucher',
      builder: (context, state) => const ManageVoucherAdmin(),
      redirect: (context, state) => _authGuard(state),
    ),

    // GoRoute(
    //   path: '/',
    //   name: 'WanderCrew',
    //   builder: (context, state) => const TestScreen(),
    // ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page not found')),
  ),
);


// Middleware auth check
String? _authGuard(GoRouterState state) {
  final AuthService authService = AuthService.to;
  if (!authService.isLoggedIn.value) {
    return Routes.adminLogin; // Redirect to login if not authenticated
  }
  return null; // Allow access if authenticated
}



class Routes {
  // static const String wanderCrew = '/';


  static const String receptionHome = '/reception';
  static const String receptionMenu = '/reception/menu';
  static const String receptionMenuCart = '/reception/menu/cart';
  static const String receptionCheckIn = '/reception/checkIn';
  static const String receptionTrackOrder = '/reception/track-order';

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

    final AuthService authService = AuthService.to;
    if (!authService.isLoggedIn.value) {

      return RouteSettings(
        name: Routes.adminLogin,
        arguments: {
          'redirect': route,
        },
      );
    }
    return null;
  }
}
