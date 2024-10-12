import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:wandercrew/pages/admin/users_admin/widgets/add_user_data.dart';
import 'dart:html' as html;
import '../../../models/user_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class ManageUserAdminController extends GetxController {


  RxList<AdminUserModel> userDataList = <AdminUserModel>[].obs;
  RxList<AdminUserModel> originalUserDataList = <AdminUserModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchUserDataList(); // Fetch data when controller is initialized
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      userDataList.value = List.from(originalUserDataList); // Restore the original data
    } else {
      userDataList.value = originalUserDataList.where((item) {
        final queryLower = query.toLowerCase();

        return item.name.toLowerCase().contains(queryLower) ||
            item.number.toLowerCase().contains(queryLower) ||
            item.userId.toLowerCase().contains(queryLower)
        ;
      }).toList();
    }
    update();
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
      originalUserDataList.assignAll(newList);
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
          originalUserDataList.remove(userData);

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
        userData.isOnline = !isOnline;
        throw Exception("User not found");
      }
    } catch (error) {
      // If there's an error, revert the UI back to the previous state
      userData.isOnline = !isOnline;
      update();
      Get.snackbar('Error', 'Failed to update online status: $error');
    }
  }





  static Future<pw.ImageProvider> _fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return pw.MemoryImage(bytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  // Helper function to build a text row for info
  static pw.Widget  _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text('$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }

  static Future<void> _savePdf(pw.Document pdf, String fileName) async {
    // For Web
    if (kIsWeb) {
      final pdfBytes = await pdf.save();
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final html.AnchorElement anchorElement = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
      // await Printing.sharePdf(bytes: pdfBytes, filename: 'checkin_details.pdf');
    } else {
      // For Mobile (Android/iOS)
      final pdfBytes = await pdf.save();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/checkin_details.pdf');
      await file.writeAsBytes(pdfBytes);
      await Printing.sharePdf(bytes: pdfBytes, filename: 'checkin_details.pdf');
    }
  }


  Future<void> downloadUserData(AdminUserModel checkInItem) async {
    final pdf = pw.Document();

    // Fetch images first
    final frontImage = await _fetchImage(checkInItem.frontDocumentUrl);
    var backImage;
    if(checkInItem.backDocumentUrl != null ) backImage = await _fetchImage(checkInItem.backDocumentUrl!);
    // Add a page with text and images
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Check-In Details',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                _buildInfoRow('id', checkInItem.id),
                _buildInfoRow('Document Type', checkInItem.documentType),
                _buildInfoRow('name', checkInItem.name),
                _buildInfoRow('userId', checkInItem.userId.toString()),
                _buildInfoRow('password', checkInItem.password),
                _buildInfoRow('role', checkInItem.role),
                _buildInfoRow('permission', checkInItem.permission),
                _buildInfoRow('number', checkInItem.number),
                _buildInfoRow('address', checkInItem.address),
                _buildInfoRow('permission', checkInItem.permission),
                // _buildInfoRow('loginData', checkInItem.loginData),

                pw.SizedBox(height: 10),
                pw.Text('Documents',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Image(
                    frontImage, height: 150, width: 150, fit: pw.BoxFit.cover),
                pw.SizedBox(height: 10),
                if(checkInItem.backDocumentUrl !=null)
                  pw.Image(
                      backImage, height: 150, width: 150, fit: pw.BoxFit.cover),
                pw.SizedBox(height: 10),

              ],
            ),
      ),
    );

    // Generate the PDF as bytes and save it
    await _savePdf(pdf, "${checkInItem.name} User Details.pdf");
  }

}
