import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import '../../../../models/menu_item_model.dart';
import '../../../../service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFoodItemController extends GetxController {
  var categories =
      <String>[].obs; // List of food categories fetched from Firebase
  var selectedCategory = Rxn<String>(); // Currently selected category
  Rxn<dynamic> selectedImage = Rxn<dynamic>(); // Selected image

  // TextEditingControllers for required fields
  var idController = TextEditingController();
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();

  // TextEditingControllers for optional fields
  var discountPriceController = TextEditingController();
  var stockCountController = TextEditingController();
  var notesController = TextEditingController();
  var preparationTimeController = TextEditingController();
  var tagsController =
      TextEditingController(); // For storing comma-separated tags
  var ingredientsController = TextEditingController();

  // Boolean fields
  var isAvailable = true.obs;
  var isVeg = true.obs;
  var isFeatured = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    fetchCategories(); // Fetch categories from Firebase
    super.onInit();
  }

  // Fetches the categories from the "Menu_Category" collection in Firestore
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot categorySnapshot =
          await FirebaseFirestore.instance.collection("Menu_Category").get();
      categories.clear();
      for (var doc in categorySnapshot.docs) {
        categories.add(doc['categoryName']); // Add categories to the list
      }
      if (categories.isNotEmpty) {
        selectedCategory.value =
            categories[0]; // Set the first category as default
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories from Firebase.");
    }
  }

  // Image picker function (Web or Mobile)
  Future<void> pickImage() async {
    if (kIsWeb) {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();
        selectedImage.value = imageBytes; // Store bytes for web
      }
    } else {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage.value = File(pickedImage.path); // Store file for mobile
      }
    }
  }

  // Uploads the food item to Firebase, mapping it using the MenuItemModel class
  Future<void> uploadItem() async {
    if (selectedImage.value != null &&
        nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedCategory.value != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        String addId = randomAlphaNumeric(10);

        // Upload image to Firebase Storage
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("foodImages").child(addId);
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        UploadTask task;
        if (kIsWeb) {
          task = firebaseStorageRef.putData(
              selectedImage.value as Uint8List, metadata);
        } else {
          task = firebaseStorageRef.putFile(selectedImage.value as File);
        }

        TaskSnapshot taskSnapshot = await task;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Prepare the data using the MenuItemModel class
        MenuItemModel newItem = MenuItemModel(
          id: idController.text,
          name: nameController.text,
          price: double.parse(priceController.text),
          category: selectedCategory.value!,
          isAvailable: isAvailable.value,
          isVeg: isVeg.value,
          image: downloadUrl,
          description: descriptionController.text.isNotEmpty
              ? descriptionController.text
              : null,
          noOfOrders: 0,
          discountPrice: discountPriceController.text.isNotEmpty
              ? double.tryParse(discountPriceController.text)
              : null,
          stockCount: stockCountController.text.isNotEmpty
              ? int.tryParse(stockCountController.text)
              : null,
          notes: notesController.text.isNotEmpty ? notesController.text : null,
          preparationTime: preparationTimeController.text.isNotEmpty
              ? int.tryParse(preparationTimeController.text)
              : null,
          isFeatured: isFeatured.value,
          tags: tagsController.text.isNotEmpty
              ? tagsController.text.split(',')
              : null, // Convert tags to list
          ingredients: ingredientsController.text.isNotEmpty
              ? ingredientsController.text.split(',')
              : null, // Convert ingredients to list
          createdBy: "admin", // Replace with actual user ID logic
          createdAt: FieldValue.serverTimestamp(),
        );

        // Add the item to the Firestore database
        await DatabaseMethods()
            .addFoodItem(newItem.toMap())
            .then((_) {
          Get.back(); // Close loading dialog
          Get.snackbar(
            "Success",
            "Food Item has been added Successfully",
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
          );
          clearFields();
        });
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to add the item: $e",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } finally {
        Get.toNamed('/admin/home');
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

  // Clears all input fields after submission
  void clearFields() {
    idController.clear();
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    discountPriceController.clear();
    stockCountController.clear();
    notesController.clear();
    preparationTimeController.clear();
    tagsController.clear();
    ingredientsController.clear();
    selectedImage.value = null;
    selectedCategory.value = null;
  }
}
