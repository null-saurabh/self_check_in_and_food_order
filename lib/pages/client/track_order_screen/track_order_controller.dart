import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/food_order_model.dart';

class TrackOrderController extends GetxController {

TextEditingController trackNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


RxList<FoodOrderModel> trackOrderList =
    <FoodOrderModel>[].obs;


  Future<void> trackOrder() async {
    // Validate form fields
    if (!formKey.currentState!.validate()) {
      return; // If form is invalid, do not proceed
    }

    String phoneNumber = trackNumberController.text.trim();

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      // Fetch orders matching the entered phone number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Orders")
          .where('contactNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Get.back();
        Get.snackbar('No Orders Found', 'No orders found for this phone number');
        return;
      }

      List<FoodOrderModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FoodOrderModel.fromMap(data); // Using fromMap factory constructor
      }).toList();

      // Sort orders by orderDate, latest first
      newList.sort((a, b) => b.orderDate.compareTo(a.orderDate)); // Descending order

      // Update the list with the tracked orders
      trackOrderList.assignAll(newList);

      update(); // Notify the UI to update
      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    }
  }



}