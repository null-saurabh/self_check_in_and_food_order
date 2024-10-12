import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/auth_services.dart';

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

          print(DateTime.now());
          loginData.add(DateTime.now());

          // Update Firestore with new login data and set isOnline to true
          await FirebaseFirestore.instance
              .collection("AdminAccount")
              .doc(result.id)
              .update({
            'loginData': loginData.map((date) => Timestamp.fromDate(date)).toList(),
          });

          // Proceed with the login flow
          AuthService.to.login();

          // Check for intended route (if any)
          Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
          String? intendedRoute = args != null ? args['redirect'] : null;

          if (intendedRoute != null && intendedRoute.isNotEmpty) {
            Get.offAllNamed(intendedRoute);
          }
          else {
            Get.offAllNamed('/admin/home');
          }
        } else {
          Get.snackbar(
            "Error",
            "Invalid Password",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
          );
        }
      }

      else {
        Get.snackbar(
          "Error",
          "Invalid username",
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
