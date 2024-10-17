import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';
import '../../../models/menu_item_model.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/dialog_widget.dart';
import '../../../widgets/edit_text.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/widget_support.dart';

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
      debugPrint(e.toString());
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


  Future<void> editMenuItem(BuildContext context,MenuItemModel item) async {
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
        return AddFoodItem(item: item,isEdit: true,); // Your widget for the bottom sheet
      },
    );


  }

  Future<void> deleteMenuItem(BuildContext context,MenuItemModel item) async {
    // Show a confirmation dialog


var result  = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand with the keyboard
      backgroundColor: const Color(0xffF4F5FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        // print("delete 2");
        return DialogWidget(); // Your widget for the bottom sheet
      },
    );



    if (result != null && result) {
      try {

        showDialog(
          context: context,
          barrierDismissible: false, // Prevents the user from dismissing the dialog
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

          // Delete the document using the retrieved document ID
          await FirebaseFirestore.instance.collection("Menu").doc(item.id).delete();
          originalMenuItems.remove(item);
          allMenuItems.remove(item);
          update();

        context.pop();


          final snackBar = SnackBar(
            content: Text("Menu item deleted successfully."),
            backgroundColor: Colors.green,
          );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);


      } catch (error) {

        context.pop();

        final snackBar = SnackBar(
          content: Text("Failed to delete menu item. Please try again."),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }

  Future<void> toggleAvailability(BuildContext context,MenuItemModel item, bool isAvailable) async {
    // Store the previous state to revert if needed
    bool previousState = item.isAvailable;

    // Immediately update local item availability for a smoother UI
    item.isAvailable = isAvailable;
    update();

    try {



        // Update the document in Firestore
        await FirebaseFirestore.instance
            .collection("Menu")
            .doc(item.id)
            .update({'isAvailable': isAvailable});

        // Optionally, show a success snackbar

        final snackBar = SnackBar(
          content: Text("Availability updated successfully."),
          backgroundColor: Colors.green,
        );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);


    } catch (e) {
      // Handle any errors by reverting to the previous state
      item.isAvailable = previousState;
      update();

      final snackBar = SnackBar(
        content: Text("Failed to update availability. Please try again.$e"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }


  Future<void> editMenuItemPrice(BuildContext context, MenuItemModel item) async {
    TextEditingController priceController = TextEditingController(text: item.price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12.0), // Customize the radius here
          ),
          backgroundColor: Color(0xffFFFEF9),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(top: 20, right: 20.0, left: 20),
                  child: Text(
                    "Modify",
                    style: AppWidget.black20Text600Style(),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16, right: 20.0, left: 20),
                  child: ElevatedContainer(
                    child: EditText(
                      labelFontWeight: FontWeight.w600,
                      labelText: "Price",
                      hint: "Enter Price",
                      controller:priceController,
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppElevatedButton(
                      onPressed: (){
                        context.pop();
                      },
                      title: "Back",
                      titleTextColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      showBorder: true,
                    ),
                    SizedBox(width: 12,),
                    AppElevatedButton(
                      onPressed: () async {
                        double newPrice = double.parse(priceController.text);


                        // Update the price in the database
                        await FirebaseFirestore.instance.collection("Menu").doc(item.id).update({'price': newPrice});

                        // Update local item price
                        item.price = newPrice;
                        update();

                        // Close the dialog
                        Navigator.of(context).pop();
                      },

                      title: "Apply",
                    ),
                  ],
                ),
                SizedBox(height: 16),

              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> editMenuItemNote(BuildContext context, MenuItemModel item) async {
    TextEditingController noteController = TextEditingController(text: item.notes ?? "");

    showDialog(
      context: context,
      builder: (context) {

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12.0), // Customize the radius here
          ),
          backgroundColor: Color(0xffFFFEF9),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(top: 20, right: 20.0, left: 20),
                  child: Text(
                    "Modify",
                    style: AppWidget.black20Text600Style(),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16, right: 20.0, left: 20),
                  child: ElevatedContainer(
                    child: EditText(
                      labelFontWeight: FontWeight.w600,
                      labelText: "Note",
                      hint: "Enter Note",
                      controller:noteController,
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppElevatedButton(
                      onPressed: (){
                        context.pop();
                      },
                      title: "Back",
                      titleTextColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      showBorder: true,
                    ),
                    SizedBox(width: 12,),
                    AppElevatedButton(
                      onPressed: () async {
                        String newNote = noteController.text;

                        // Update the note in the database
                        await FirebaseFirestore.instance.collection("Menu").doc(item.id).update({'notes': newNote});

                        // Update local item note
                        item.notes = newNote;
                        update();

                        // Close the dialog
                        Navigator.of(context).pop();


                      },

                      title: "Apply",
                    ),
                  ],
                ),
                SizedBox(height: 16),

              ],
            ),
          ),
        );

      },
    );
  }

}
