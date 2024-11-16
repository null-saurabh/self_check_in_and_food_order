import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      print("login 0");

      await AuthService.to.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      print("login 1");
      // Fetch the logged-in user's docId from Firebase Auth
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      print("login 2");
      // Update the login timestamp in Firestore
      await FirebaseFirestore.instance
          .collection("AdminAccount")
          .doc(userId) // Use docId of the logged-in user
          .update({
        'loginData': FieldValue.arrayUnion([Timestamp.fromDate(DateTime.now())]),
      });


          String? intendedRoute = Uri.decodeComponent(GoRouterState.of(context).uri.queryParameters['redirect'] ?? '');
          if (intendedRoute != "" && intendedRoute.isNotEmpty) {
            // context.replace(intendedRo;
            navigateToScreen(context,intendedRoute);


          }
          else {
            navigateToScreen(context,Routes.adminHome);

            // context.replace(Routes.adminHome);

          }

    } catch (e) {

      print(e);
      final snackBar = SnackBar(
        content:  Text("Failed to log in hjh. $e"),
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
