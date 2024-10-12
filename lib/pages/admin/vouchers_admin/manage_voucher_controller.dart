import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/voucher_model.dart';

class ManageVoucherAdminController extends GetxController {


  RxList<CouponModel> voucherList = <CouponModel>[].obs;
  RxList<CouponModel> originalVoucherList = <CouponModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVoucherList(); // Fetch data when controller is initialized
  }

  void filterVoucher(String query) {
    if (query.isEmpty) {
      voucherList.value = List.from(originalVoucherList); // Restore the original data
    } else {
      voucherList.value = originalVoucherList.where((item) {
        final queryLower = query.toLowerCase();

        print("$queryLower : ${item.discountValue}");
        return item.code.toLowerCase().contains(queryLower) ||
            item.discountValue.toString() == queryLower ||
            item.usageCount.toString()  == queryLower ||
            item.usageLimit.toString()  == queryLower ||
            item.maxDiscount.toString()  == queryLower ||
            item.minOrderValue.toString()  == queryLower;
      }).toList();
    }
    update();
  }


  Future<void> fetchVoucherList() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Voucher").get();

      // Mapping Fire store data to model and updating observable list
      List<CouponModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return CouponModel.fromMap(
            data); // Using fromMap factory constructor
      }).toList();
      // print(newList);

      // Updating observable list
      voucherList.assignAll(newList);
      originalVoucherList.assignAll(newList);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch list $e');
      // print(e);
    }
  }

  void toggleVoucherActiveStatus(CouponModel voucherData, bool isActive) async {
    // Update UI first (optimistic update)
    voucherData.isActive = isActive;
    update();

    try {
      // Query the correct document by userId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Voucher")
          .where("voucherId", isEqualTo: voucherData.voucherId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        // Update the online status in the correct document
        await FirebaseFirestore.instance
            .collection("Voucher")
            .doc(docId)
            .update({'isActive': isActive});
      } else {
        voucherData.isActive = !isActive;
        throw Exception("User not found");
      }
    } catch (error) {
      // If there's an error, revert the UI back to the previous state
      voucherData.isActive = !isActive;
      update();
      Get.snackbar('Error', 'Failed to update online status: $error');
    }
  }

  Future<void> refreshAndExpireCoupons() async {

    final now = DateTime.now();
    final firestore = FirebaseFirestore.instance;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Fetch all active coupons that are not expired
      final snapshot = await firestore
          .collection('Voucher')
          // .where('isActive', isEqualTo: true)
          .where('isUsed', isEqualTo: false)
          .get();

      for (var doc in snapshot.docs) {
        final couponData = doc.data();
        final validUntil = (couponData['validUntil'] as Timestamp).toDate();
        final validFrom = (couponData['validFrom'] as Timestamp).toDate();

        // Expire the coupon if it's past the validUntil date
        if (now.isAfter(validUntil.add(Duration(days: 1))) || now.isBefore(validFrom)) {
          await doc.reference.update({'isExpired': true,'isActive':false});
        }
        else{
          await doc.reference.update({'isExpired': false});
        }
      }

      fetchVoucherList();
      Get.back();
      Get.snackbar(
        "Success",
        "Vouchers updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to update voucher.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error expiring coupons: $e');
    }
  }


  Future<void> deleteVoucher(CouponModel voucherData) async {


    // Show a confirmation dialog
    bool? confirmed = await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this menu item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Query the document with matching custom 'id' field
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("Voucher")
            .where("voucherId", isEqualTo: voucherData.voucherId) // Assuming 'id' is the custom field name in Firestore
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID
          String docId = querySnapshot.docs.first.id;

          // Delete the document using the retrieved document ID
          await FirebaseFirestore.instance.collection("Voucher").doc(docId).delete();
          voucherList.remove(voucherData);
          update();
          Get.back();

          // Show success snackbar
          Get.snackbar(
            "Success",
            "Menu item deleted successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.back();

          // No matching document found
          Get.snackbar(
            "Error",
            "Menu item not found.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (error) {
        Get.back();
        // Show error snackbar
        Get.snackbar(
          "Error",
          "Failed to delete menu item. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

}