import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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


  var isLoading = true.obs; // Loading state

  var selectedFilter = 'All'
      .obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserDataList(); // Fetch data when controller is initialized
  }

  void searchFilterUsers(String query) {
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

  void filterOrdersByStatus({required String label}) {

    selectedFilter.value = label;

    if (label == 'All') {
      userDataList.assignAll(originalUserDataList);
    }

    else {
      userDataList.value = originalUserDataList.where((userData) {
        return userData.isOnline == true;
      }).toList();
    }

    // Ensure orders are sorted by orderDate (latest first)
    update();
  }


  void makePhoneCall(String number) {
    String phoneNumber = '$number';
    html.window.open('tel:$phoneNumber', '_self');
  }

  Future<void> fetchUserDataList() async {
    try {
      isLoading.value = true; // Start loading

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
      debugPrint(e.toString());

      // print(e);
    }
    finally {
      isLoading.value = false; // End loading
    }
  }

  Future<void> deleteUser(BuildContext context,AdminUserModel userData) async {


    // Show a confirmation dialog
    bool? confirmed = await showDialog(
      context: context,
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


      try {

        showDialog(
          context: context,
          barrierDismissible: false, // Prevents the user from dismissing the dialog
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        // Check if the document exists before attempting to delete
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection("AdminAccount")
            .doc(userData.id)
            .get();

        if (docSnapshot.exists) {
          // Delete the document if it exists
          await FirebaseFirestore.instance.collection("AdminAccount").doc(userData.id).delete();
          originalUserDataList.remove(userData);

          update();
          context.pop();

          final snackBar = SnackBar(
            content: Text("Success: User deleted successfully."),
            backgroundColor: Colors.green,
          );

          // Show the success snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // Document does not exist, show error snackbar
          context.pop();

          final snackBar = SnackBar(
            content: Text("Error: User not found, deletion failed."),
            backgroundColor: Colors.red,
          );

          // Show the error snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }


      } catch (error) {
        context.pop();
        // Show error snackbar
        final snackBar = SnackBar(
          content: Text("Failed to delete user. Please try again."),
          backgroundColor: Colors.red,
        );

// Show the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }

  Future<void> editUserData(BuildContext context,AdminUserModel data) async {
    // Implement edit logic
    // This is a placeholder

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand with the keyboard
      backgroundColor: const Color(0xffF4F5FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddNewUserAdmin(data: data,isEdit: true,); // Your widget for the bottom sheet
      },
    );

    // Get.bottomSheet(
    //   AddNewUserAdmin(data: data,isEdit: true,),
    //   isScrollControlled: true, // Allows the bottom sheet to expand with keyboard
    //   backgroundColor: Color(0xffF4F5FA),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //   ),
    // );
    // print("Edit Menu Item: ${item.name}");
  }

  void toggleUserOnlineStatus(BuildContext context,AdminUserModel userData, bool isOnline) async {
    // Update UI first (optimistic update)
    userData.isOnline = isOnline;
    update();

    try {
      // Query the correct document by userId
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection("AdminAccount")
      //     .where("userId", isEqualTo: userData.userId)
      //     .get();
      //
      // if (querySnapshot.docs.isNotEmpty) {
      //   String  = querySnapshot.docs.first.id;

        // Update the online status in the correct document
        await FirebaseFirestore.instance
            .collection("AdminAccount")
            .doc(userData.id)
            .update({'isOnline': isOnline});
      // } else {
      //   userData.isOnline = !isOnline;
      //   throw Exception("User not found");
      // }
    } catch (error) {
      // If there's an error, revert the UI back to the previous state
      userData.isOnline = !isOnline;
      update();
      final snackBar = SnackBar(
        content: Text("Failed to update online status: $error"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
    }
  }


  Future<void> downloadUserData(BuildContext context,AdminUserModel checkInItem) async {
    try {


      showDialog(
        context: context,
        barrierDismissible: false, // Prevents the user from dismissing the dialog
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      final pdf = pw.Document();

      // Fetch images first
      final frontImage = await _fetchImage(checkInItem.frontDocumentUrl);
      var backImage;
      if (checkInItem.backDocumentUrl != null)
        backImage = await _fetchImage(checkInItem.backDocumentUrl!);
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
                      frontImage, height: 150,
                      width: 150,
                      fit: pw.BoxFit.cover),
                  pw.SizedBox(height: 10),
                  if(checkInItem.backDocumentUrl != null)
                    pw.Image(
                        backImage, height: 150,
                        width: 150,
                        fit: pw.BoxFit.cover),
                  pw.SizedBox(height: 10),

                ],
              ),
        ),
      );

      // Generate the PDF as bytes and save it
      await _savePdf(pdf, "${checkInItem.name} User Details.pdf");
      context.pop();

    }
    catch (e){

      context.pop();

      final snackBar = SnackBar(
        content: Text("Failed to download $e"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


    }
  }

}
