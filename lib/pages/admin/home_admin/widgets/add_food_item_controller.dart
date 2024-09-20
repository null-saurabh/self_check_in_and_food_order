import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:wandercrew/widgets/bottom_nav.dart';
import '../../../../service/database.dart';

class AddFoodItemController extends GetxController {
  var foodItems = ['Breakfast', 'Lunch', 'Dinner', 'Beverages'].obs;
  var selectedCategory = Rxn<String>();
  // var selectedImage = Rxn<File>();
  Rxn<dynamic> selectedImage = Rxn<dynamic>();
  var idController = TextEditingController();
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var detailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Future<void> pickImage() async {
  //   final image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     selectedImage.value = File(image.path);
  //   }
  // }

  Future<void> pickImage() async {
    if (kIsWeb) {
      // For web, use a different image picker approach or Image.network
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();
        selectedImage.value = imageBytes; // Store bytes for web use
      }
    } else {
      // For mobile platforms
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage.value = File(pickedImage.path);  // Store file for mobile
      }
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage.value != null &&
        nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        detailController.text.isNotEmpty &&
        selectedCategory.value != null) {

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        String addId = randomAlphaNumeric(10);
        // print("ab");

        Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("foodImages").child(addId);
        // print("abb");
        UploadTask task;
        if (kIsWeb) {
          // For web, use putData() since selectedImage.value is Uint8List
          task = firebaseStorageRef.putData(selectedImage.value as Uint8List);
        } else {
          // For mobile, use putFile() since selectedImage.value is File
          task = firebaseStorageRef.putFile(selectedImage.value as File);
        }

        TaskSnapshot taskSnapshot = await task;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();


        // final UploadTask task = firebaseStorageRef.putFile(selectedImage.value!);
        // print("abc");

        // var downloadUrl = await (await task).ref.getDownloadURL();
        // print("abcd");

        Map<String, dynamic> addItem = {
          "productId": idController.text,
          "productImage": downloadUrl,
          "productName": nameController.text,
          "productPrice": priceController.text,
          "Detail": detailController.text,
          "category": selectedCategory.value,
        };
        // print("abcde");

        await DatabaseMethods().addFoodItem(addItem, selectedCategory.value!).then((_) {
          // print("abcdef");
          Get.snackbar(
            "Success",
            "Food Item has been added Successfully",
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
          );
          clearFields();
        });
      } catch (e) {
        // print("abcdefg");
        // print(e);
        Get.snackbar(
          "Error",
          "Failed to add the item: $e",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } finally {
        // print("abcdefgh");
        Get.back(); // Close loading dialog
        // Get.offNamed('/bottomNav');
        Get.to(() => const BottomNav());
      }
    } else {
      Get.snackbar(
        "Error",
        "Please fill in all fields and select an image.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void clearFields() {
    idController.clear();
    nameController.clear();
    priceController.clear();
    detailController.clear();
    selectedImage.value = null;
    selectedCategory.value = null;
  }
}
