import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/auth_services.dart';
import '../home_admin/home_admin.dart';

class AdminLoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  RxBool isLoading = false.obs;

  // Login function
  Future<void> loginAdmin() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Admin")
          .get();

      bool validUser = false;

      for (var result in snapshot.docs) {
        if (result['id'] == usernameController.text.trim() &&
            result['password'] == passwordController.text.trim()) {
          validUser = true;
          // Get.offAllNamed('/admin/home');
          // Get.offAll(() => const HomeAdmin()); // Navigate to HomeAdmin
          // print("a");
          // authService.login();
          AuthService.to.login();

          // String? intendedRoute = Get.parameters['redirect'];
          Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
          String? intendedRoute = args != null ? args['redirect'] : null;
          // print("b");
          // print(intendedRoute);


          if (intendedRoute != null && intendedRoute.isNotEmpty) {
            // If there is an intended route, navigate to it
            // print("c");
            Get.offAllNamed(intendedRoute);
          } else {
            // print("d");
            // If no intended route, navigate to admin home page
            Get.offAllNamed('/admin/home');
          }
          break;
        }
      }

      if (!validUser) {
        Get.snackbar(
          "Error",
          "Invalid username or password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to log in. Try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
