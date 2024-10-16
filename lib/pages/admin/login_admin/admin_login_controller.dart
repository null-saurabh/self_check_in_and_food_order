import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../service/auth_services.dart';
import '../../../utils/routes.dart';
import 'dart:html' as html;

class AdminLoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  RxBool isLoading = false.obs;

  // Login function
  Future<void> loginAdmin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("AdminAccount")
          .where("userId", isEqualTo: usernameController.text.trim())
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final result = snapshot.docs.first;

        if (result['password'] == passwordController.text.trim()) {
          // Add the current login timestamp to loginData

          List<DateTime> loginData = List<DateTime>.from(
              result['loginData'].map((timestamp) => (timestamp as Timestamp).toDate()));

          // print(DateTime.now());
          loginData.add(DateTime.now());

          await FirebaseFirestore.instance
              .collection("AdminAccount")
              .doc(result.id)
              .update({
            'loginData': loginData.map((date) => Timestamp.fromDate(date)).toList(),
          });

          AuthService.to.login();

          // final Map<String, dynamic>? args = GoRouter.of(context).extra as Map<String, dynamic>?;
          // String? intendedRoute = args != null ? args['redirect'] : null;

          String? intendedRoute = Uri.decodeComponent(GoRouterState.of(context).uri.queryParameters['redirect'] ?? '');
          if (intendedRoute != "" && intendedRoute.isNotEmpty) {
            // context.replace(intendedRo;
            navigateToScreen(context,intendedRoute);


          }
          else {
            navigateToScreen(context,Routes.adminHome);

            // context.replace(Routes.adminHome);

          }
        } else {

          final snackBar = SnackBar(
            content: const Text("Invalid Password"),
            backgroundColor: Colors.orangeAccent,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
      }

      else {

        final snackBar = SnackBar(
          content: const Text("Invalid username"),
          backgroundColor: Colors.orangeAccent,
        );

// Show the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);


      }
    } catch (e) {


      final snackBar = SnackBar(
        content: const Text("Failed to log in. Try again later."),
        backgroundColor: Colors.redAccent,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } finally {
      isLoading.value = false;
    }
  }

  void navigateToScreen(BuildContext context, String route) {

    html.window.history.replaceState({}, '', '/admin');
    // html.window.history.replaceState({}, '', Routes.receptionHome);
    context.go(route);

  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
