import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';
import '../../../models/menu_item_model.dart';

class MenuAdminController extends GetxController {
  RxList<MenuItemModel> allMenuItems = RxList<MenuItemModel>();
  List<MenuItemModel> originalMenuItems = []; // Store original data

  ScrollController scrollController = ScrollController();
  TextEditingController filterMinItemPrice = TextEditingController();
  TextEditingController filterMaxItemPrice = TextEditingController();
  RxnString selectedVegFilter = RxnString();
  RxnString selectedAvailableFilter = RxnString();


  var isLoading = true.obs; // Loading state

  @override
  void onInit() {
    fetchMenuData();
    super.onInit();
  }

  Future<void> fetchMenuData() async {
    try {
      isLoading.value = true; // Start loading

      QuerySnapshot value = await FirebaseFirestore.instance.collection("Menu").get();
      originalMenuItems = value.docs.map((doc) {
        return MenuItemModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      allMenuItems.value = List.from(originalMenuItems); // Update displayed list
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data");
      print("Error fetching menu data: $e");
    }finally {
      // print("Aaaaa");
      isLoading.value = false; // End loading
    }
  }

  void searchFilterMenuItems(String query) {
    if (query.isEmpty) {
      allMenuItems.value = List.from(originalMenuItems); // Restore the original data
    } else {
      allMenuItems.value = originalMenuItems.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  void clearFilter(){

    filterMaxItemPrice.clear();
    filterMinItemPrice.clear();
    selectedVegFilter.value = null;
    selectedAvailableFilter.value = null;

    allMenuItems.value = List.from(originalMenuItems);
    update();
  }


  void applyFilters() {
    allMenuItems.value = originalMenuItems.where((order) {
      bool matchesOrderValue = true;
      bool matchesVeg = true;
      bool matchesAvailable = true;

      // Check if the min order value is provided
      if (filterMinItemPrice.text.isNotEmpty) {
        double minValue = double.tryParse(filterMinItemPrice.text) ?? 0.0;
        matchesOrderValue = order.price >= minValue;
      }

      // Check if the max order value is provided
      if (filterMaxItemPrice.text.isNotEmpty) {
        double maxValue = double.tryParse(filterMaxItemPrice.text) ?? 1000.0;
        matchesOrderValue = matchesOrderValue && order.price <= maxValue;
      }

      // Check if the start date is provided
      if (selectedAvailableFilter.value != null && selectedAvailableFilter.value!.isNotEmpty) {
        matchesAvailable = order.isAvailable == (selectedAvailableFilter.value == "On");
      }

      // Check if the end date is provided
      if (selectedVegFilter.value != null && selectedVegFilter.value!.isNotEmpty) {
        matchesVeg = order.isVeg == (selectedVegFilter.value == "Veg");
      }

      return matchesOrderValue && matchesVeg && matchesAvailable;
    }).toList();

    // Sort the filtered orders by date (latest first)
    update();
  }


  Future<void> editMenuItem(MenuItemModel item) async {
    // Implement edit logic
    // This is a placeholder
    Get.bottomSheet(
      AddFoodItem(item: item,isEdit: true,),
      isScrollControlled: true, // Allows the bottom sheet to expand with keyboard
      backgroundColor: Color(0xffF4F5FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
    // print("Edit Menu Item: ${item.name}");
  }

  Future<void> deleteMenuItem(BuildContext context,MenuItemModel item) async {
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
        // Query the document with matching custom 'id' field
        // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        //     .collection("Menu")
        //     .where("productId", isEqualTo: item.id) // Assuming 'id' is the custom field name in Firestore
        //     .get();

        // if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID
          // String docId = querySnapshot.docs.first.id;

          // Delete the document using the retrieved document ID
          await FirebaseFirestore.instance.collection("Menu").doc(item.id).delete();
          originalMenuItems.remove(item);
          allMenuItems.remove(item);
          update();

          // Show success snackbar
          Get.snackbar(
            "Success",
            "Menu item deleted successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

        // else {
        //   // No matching document found
        //   Get.snackbar(
        //     "Error",
        //     "Menu item not found.",
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.red,
        //     colorText: Colors.white,
        //   );
        // }
      } catch (error) {
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

  Future<void> toggleAvailability(MenuItemModel item, bool isAvailable) async {
    // Store the previous state to revert if needed
    bool previousState = item.isAvailable;

    // Immediately update local item availability for a smoother UI
    item.isAvailable = isAvailable;
    update();

    try {
      // Query to get the correct document by custom 'productId' field
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection("Menu")
      //     .where("productId", isEqualTo: item.id) // Assuming 'id' is the custom field
      //     .get();
      //
      // if (querySnapshot.docs.isNotEmpty) {
      //   String docId = querySnapshot.docs.first.id;

        // Update the document in Firestore
        await FirebaseFirestore.instance
            .collection("Menu")
            .doc(item.id)
            .update({'isAvailable': isAvailable});

        // Optionally, show a success snackbar
        Get.snackbar(
          "Success",
          "Availability updated successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      // }
      // else {
      //   // If the document is not found, revert to the previous state
      //   item.isAvailable = previousState;
      //   update();
      //
      //   Get.snackbar(
      //     "Error",
      //     "Menu item not found.",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //   );
      // }
    } catch (e) {
      // Handle any errors by reverting to the previous state
      item.isAvailable = previousState;
      update();

      // Show an error snackbar
      Get.snackbar(
        "Error",
        "Failed to update availability. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<void> editMenuItemPrice(BuildContext context, MenuItemModel item) async {
    TextEditingController priceController = TextEditingController(text: item.price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Price"),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Price"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                double newPrice = double.parse(priceController.text);

                // Query to get the correct document by custom 'id' field
                // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                //     .collection("Menu")
                //     .where("productId", isEqualTo: item.id) // Assuming 'id' is the custom field
                //     .get();
                //
                // if (querySnapshot.docs.isNotEmpty) {
                //   String  = querySnapshot.docs.first.id;

                  // Update the price in the database
                  await FirebaseFirestore.instance.collection("Menu").doc(item.id).update({'price': newPrice});

                  // Update local item price
                  item.price = newPrice;
                  update();

                  // Close the dialog
                  Navigator.of(context).pop();
                // } else {
                //   // Show error snackbar if no matching document is found
                //   Get.snackbar(
                //     "Error",
                //     "Menu item not found.",
                //     snackPosition: SnackPosition.BOTTOM,
                //     backgroundColor: Colors.red,
                //     colorText: Colors.white,
                //   );
                // }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> editMenuItemNote(BuildContext context, MenuItemModel item) async {
    TextEditingController noteController = TextEditingController(text: item.notes ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: TextField(
            controller: noteController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: "Note"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newNote = noteController.text;

                // Query to get the correct document by custom 'id' field
                // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                //     .collection("Menu")
                //     .where("productId", isEqualTo: item.id)
                //     .get();
                //
                // if (querySnapshot.docs.isNotEmpty) {
                //   String  = querySnapshot.docs.first.id;

                  // Update the note in the database
                  await FirebaseFirestore.instance.collection("Menu").doc(item.id).update({'notes': newNote});

                  // Update local item note
                  item.notes = newNote;
                  update();

                  // Close the dialog
                  Navigator.of(context).pop();

                // } else {
                //   // Show error snackbar if no matching document is found
                //   Get.snackbar(
                //     "Error",
                //     "Menu item not found.",
                //     snackPosition: SnackPosition.BOTTOM,
                //     backgroundColor: Colors.red,
                //     colorText: Colors.white,
                //   );
                // }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

}
