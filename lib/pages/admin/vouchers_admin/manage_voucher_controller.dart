import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/voucher_model.dart';

class ManageVoucherAdminController extends GetxController {


  RxList<CouponModel> voucherList = <CouponModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVoucherList(); // Fetch data when controller is initialized
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
          .where("id", isEqualTo: voucherData.id)
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
            .where("id", isEqualTo: voucherData.id) // Assuming 'id' is the custom field name in Firestore
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