import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:wandercrew/pages/admin/menu_admin/menu_admin_controller.dart';
import '../../../../models/menu_item_model.dart';
import '../../../../service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFoodItemController extends GetxController {


  // Add this property
  var isEditing = false.obs;
  var editingItem = Rxn<MenuItemModel>();

  // Modify the constructor to accept an item
  AddFoodItemController({MenuItemModel? item}) {
    if (item != null) {
      isEditing.value = true;
      setEditingItem(item);
    }
  }



  var categories =
      <String>[].obs; // List of food categories fetched from Firebase
  var selectedCategory = Rxn<String>(); // Currently selected category

  // TextEditingControllers for required fields
  // var idController = TextEditingController();
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var indexController = TextEditingController();
  var descriptionController = TextEditingController();

  // TextEditingControllers for optional fields
  // var discountPriceController = TextEditingController();
  var stockCountController = TextEditingController();
  var notesController = TextEditingController();
  var preparationTimeController = TextEditingController();
  var tagsController =
      TextEditingController(); // For storing comma-separated tags
  var ingredientsController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode indexFocusNode = FocusNode();
  FocusNode stockCountFocusNode = FocusNode();
  FocusNode notesFocusNode = FocusNode();
  FocusNode preparationTimeFocusNode = FocusNode();
  FocusNode tagsFocusNode = FocusNode();
  FocusNode ingredientsFocusNode = FocusNode();

  // Boolean fields
  var isAvailable = true.obs;
  var isVeg = true.obs;
  var isFeatured = false.obs;
  var showImage = false.obs;

  final ImagePicker _picker = ImagePicker();

  Rxn<dynamic> selectedImage = Rxn<dynamic>(); // Selected image
  var itemImageName = Rxn<String>();
  var isItemImageInvalid = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();





  void setEditingItem(MenuItemModel item) {
    editingItem.value = item;
    // Populate fields with item data
    // idController.text = item.id;
    nameController.text = item.name;
    priceController.text = item.price.toString();
    descriptionController.text = item.description ?? '';
    indexController.text = item.itemIndexNumber.toString();
    // Set other fields similarly
    // For the image, use just the URL
    // itemImageName.value = item.image;
    // Set selected category
    selectedCategory.value = item.category;
    isAvailable.value = item.isAvailable;
    isVeg.value = item.isVeg;
    // discountPriceController.text = item.discountPrice?.toString() ?? "";
    stockCountController.text = item.stockCount?.toString() ?? "";
    notesController.text = item.notes ?? "";
    isFeatured.value = item.isFeatured ?? false;
    tagsController.text = item.tags?.join(",") ?? "";
    ingredientsController.text = item.ingredients?.join(",") ?? "";

    update();
  }


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
      // if (categories.isNotEmpty) {
      //   selectedCategory.value =
      //       categories[0]; // Set the first category as default
      // }
      update();
    } catch (e) {
      debugPrint("Error:  Failed to load categories from Firebase. $e");
    }
  }

  // Image picker function (Web or Mobile)
  Future<void> pickImage() async {
    if (kIsWeb) {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        itemImageName.value = pickedImage.name;
        final imageBytes = await pickedImage.readAsBytes();
        selectedImage.value = imageBytes; // Store bytes for web
      }
    } else {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        itemImageName.value = pickedImage.name;
        selectedImage.value = File(pickedImage.path); // Store file for mobile
      }
    }
  }

  // Uploads the food item to Firebase, mapping it using the MenuItemModel class
  Future<void> uploadItem(BuildContext context) async {

    if (formKey.currentState!
        .validate()) {

    //
    // if (selectedImage.value != null &&
    //     nameController.text.isNotEmpty &&
    //     priceController.text.isNotEmpty &&
    //     selectedCategory.value != null) {


      showDialog(
        context: context,
        barrierDismissible: false, // Prevents the user from dismissing the dialog
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        String? downloadUrl;
        if(isEditing.value){
          downloadUrl = editingItem.value?.image ?? " ";
        }
        else if(selectedImage.value != null) {
          String addId = randomAlphaNumeric(10);

          // Upload image to Firebase Storage
          Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("foodImages").child('${nameController}_menu_$addId');
          SettableMetadata metadata = SettableMetadata(
              contentType: 'image/jpeg');
          UploadTask task;
          if (kIsWeb) {
            task = firebaseStorageRef.putData(
                selectedImage.value as Uint8List, metadata);
          } else {
            task = firebaseStorageRef.putFile(selectedImage.value as File);
          }

          TaskSnapshot taskSnapshot = await task;
          String url = await taskSnapshot.ref.getDownloadURL();
          downloadUrl =url;
        }


        // Prepare the data using the MenuItemModel class
        MenuItemModel newItem = MenuItemModel(
          id: isEditing.value ? editingItem.value!.id :"",
          name: nameController.text,
          price: double.parse(priceController.text),
          category: selectedCategory.value!,
          itemIndexNumber: int.parse(indexController.text),
          isAvailable: isAvailable.value,
          isVeg: isVeg.value,
          image: downloadUrl,
          description: descriptionController.text.isNotEmpty
              ? descriptionController.text
              : null,
          noOfOrders: isEditing.value ? editingItem.value!.noOfOrders : 0,
          // discountPrice: discountPriceController.text.isNotEmpty
          //     ? double.tryParse(discountPriceController.text)
          //     : null,
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

        if(isEditing.value){
          try {


              await DatabaseMethods().updateFoodItem( editingItem.value!.id,newItem.toMap());


              // Update the item in the lists
              MenuAdminController controller = Get.find<MenuAdminController>();
              // Find the index of the item to update
              int index = controller.allMenuItems.indexWhere((item) => item.id == editingItem.value!.id);
              if (index != -1) {
                controller.allMenuItems[index] = newItem; // Update the item in allMenuItems
                // Optionally update in originalMenuItems if needed
                int originalIndex = controller.originalMenuItems.indexWhere((item) => item.id == editingItem.value!.id);
                if (originalIndex != -1) {
                  controller.originalMenuItems[originalIndex] = newItem; // Update in originalMenuItems if needed
                }
                controller.update();
              }
              context.pop();
              context.pop();
              final snackBar = SnackBar(
                content: Text("Menu item updated successfully."),
                backgroundColor: Colors.green,
              );

// Show the snackbar
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // // Show success snackbar
              // Get.snackbar(
              //   "Success",
              //   "Menu item updated successfully.",
              //   snackPosition: SnackPosition.BOTTOM,
              //   backgroundColor: Colors.green,
              //   colorText: Colors.white,
              // );
          } catch (error) {
            context.pop();
            final snackBar = SnackBar(
              content: Text("Failed to update menu item. Please try again."),
              backgroundColor: Colors.red,
            );

// Show the snackbar
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Show error snackbar
            // Get.snackbar(
            //   "Error",
            //   "Failed to update menu item. Please try again.",
            //   snackPosition: SnackPosition.BOTTOM,
            //   backgroundColor: Colors.red,
            //   colorText: Colors.white,
            // );
          }

        }
        else {
        // Add the item to the Firestore database

          DocumentReference docRef = await DatabaseMethods()
            .addFoodItem(newItem.toMap());

          String id = docRef.id; // Retrieve the autogenerated ID

          await docRef.update({'id': id});




          MenuAdminController controller = Get.find<MenuAdminController>();
          newItem.id = id;
          controller.allMenuItems.add(newItem);
          controller.originalMenuItems.add(newItem);

          clearFields();

          context.pop(); // Close loading dialog
          context.pop(); // go back from add screen

          // Get.snackbar(
          //   "Success",
          //   "Food Item has been added Successfully",
          //   backgroundColor: Colors.orangeAccent,
          //   colorText: Colors.white,
          // );
          final snackBar = SnackBar(
            content: const Text("Success, Food Item has been added Successfully",),
            backgroundColor: Colors.orangeAccent,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        context.pop();

        final snackBar = SnackBar(
          content: Text("Failed to add the item: $e"),
          backgroundColor: Colors.redAccent,
        );

// Show the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      } finally {
      }
    } else {
      final snackBar = SnackBar(
        content: Text("Please fill in all fields"),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }



  // Clears all input fields after submission
  void clearFields() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    // discountPriceController.clear();
    stockCountController.clear();
    notesController.clear();
    preparationTimeController.clear();
    tagsController.clear();
    ingredientsController.clear();
    selectedImage.value = null;
    // selectedCategory.value = null;
  }
}
