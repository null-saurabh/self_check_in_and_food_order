import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import '../utils/routes.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  RxBool isLoggedIn = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxnString loggedInUserId = RxnString();

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        isLoggedIn.value = true;
        loggedInUserId.value = user.uid;
      } else {
        isLoggedIn.value = false;
        loggedInUserId.value = null;
      }
    }
    );
  }
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid; // Get the user ID

        // Call your method to save the token to the database
        await saveTokenToDatabase(userId,);

        isLoggedIn.value = true;
      } else {
        throw Exception("No user is currently signed in.");
      }
    } catch (e) {
      throw Exception("Login failed mj: $e");
    }
  }


  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    isLoggedIn.value = false;
    if(loggedInUserId.value != null) {
      removeTokenFromDatabase(loggedInUserId.value!);
    }
    // Replace the current route with the new route
    html.window.history.replaceState({}, '', '/admin');
    // html.window.history.replaceState({}, '', Routes.receptionHome);
    context.go(Routes.adminHome);
  }


  Future<void> saveTokenToDatabase(String userId) async {
    if (await FirebaseMessaging.instance.isSupported()) {
      String? token = await FirebaseMessaging.instance.getToken();
      // String? token = "tokkkkk";
      // print("token: $token");
      if (token != null) {
        DocumentReference userTokensRef = FirebaseFirestore.instance.collection(
            'userTokens').doc(userId);

        await userTokensRef.set({
          'tokens': FieldValue.arrayUnion([token]), // Add token to the array
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(
            merge: true)); // Merge ensures existing tokens are preserved
      }
    }
  }




  Future<void> removeTokenFromDatabase(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      DocumentReference userTokensRef = FirebaseFirestore.instance.collection('userTokens').doc(userId);

      await userTokensRef.update({
        'tokens': FieldValue.arrayRemove([token]), // Remove the specific token
      });
    }
  }

}