import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/users_admin/widgets/add_user_data.dart';
import 'dart:html' as html;
import '../../../models/user_model.dart';

class ManageUserAdminController extends GetxController {


  RxList<AdminUserModel> userDataList = <AdminUserModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchUserDataList(); // Fetch data when controller is initialized
  }

  void makePhoneCall(String number) {
    String phoneNumber = '$number';
    html.window.open('tel:$phoneNumber', '_self');
  }
  Future<void> fetchUserDataList() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("AdminAccount").get();

      // Mapping Fire store data to model and updating observable list
      List<AdminUserModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return AdminUserModel.fromMap(
            data); // Using fromMap factory constructor
      }).toList();
      // print(newList);

      // Updating observable list
      userDataList.assignAll(newList);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch list $e');
      // print(e);
    }
  }

  Future<void> deleteUser(AdminUserModel userData) async {


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
            .collection("AdminAccount")
            .where("id", isEqualTo: userData.id) // Assuming 'id' is the custom field name in Firestore
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID
          String docId = querySnapshot.docs.first.id;

          // Delete the document using the retrieved document ID
          await FirebaseFirestore.instance.collection("AdminAccount").doc(docId).delete();
          userDataList.remove(userData);
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

  Future<void> editUserData(AdminUserModel data) async {
    // Implement edit logic
    // This is a placeholder
    Get.bottomSheet(
      AddNewUserAdmin(data: data,isEdit: true,),
      isScrollControlled: true, // Allows the bottom sheet to expand with keyboard
      backgroundColor: Color(0xffF4F5FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
    // print("Edit Menu Item: ${item.name}");
  }

  void toggleUserOnlineStatus(AdminUserModel userData, bool isOnline) async {
    // Update UI first (optimistic update)
    userData.isOnline = isOnline;
    update();

    try {
      // Query the correct document by userId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Admin")
          .where("userId", isEqualTo: userData.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        // Update the online status in the correct document
        await FirebaseFirestore.instance
            .collection("Admin")
            .doc(docId)
            .update({'isOnline': isOnline});
      } else {
        throw Exception("User not found");
      }
    } catch (error) {
      // If there's an error, revert the UI back to the previous state
      userData.isOnline = !isOnline;
      update();
      Get.snackbar('Error', 'Failed to update online status: $error');
    }
  }

}
