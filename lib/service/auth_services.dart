import 'package:get/get.dart';

class AuthService extends GetxService {
  // This is just a simple example. Replace this with your actual user authentication logic.
  static AuthService get to => Get.find<AuthService>();

  RxBool isLoggedIn = false.obs;

  Future<void> login() async {
    // Your login logic here
    // If login is successful, set isLoggedIn to true
    isLoggedIn.value = true;
    // print("aa");
    // print(isLoggedIn.value);

  }

  Future<void> logout() async {
    // Your logout logic here
    isLoggedIn.value = false;
  }
}