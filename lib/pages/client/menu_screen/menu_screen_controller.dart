import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../models/menu_item_model.dart';

class MenuScreenController extends GetxController {
  RxBool isVegSelected = false.obs;
  RxBool isNonVegSelected = false.obs;

  Map<String, List<MenuItemModel>> categorizedMenuItems = {};
  RxList<MenuItemModel> allMenuItems = RxList.empty();

  // This will hold the filtered items for each category
  Map<String, List<MenuItemModel>> filteredMenuByCategory = {};

  @override
  void onInit() {
    fetchMenuData();
    super.onInit();
  }

  fetchMenuData() async {
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Menu").get();
    allMenuItems.value = value.docs.map((element) => MenuItemModel.fromMap(element.data() as Map<String, dynamic>)).toList();

    categorizeMenuItems(allMenuItems);
    applyFilters(); // Apply filters initially
    update();
  }

  void categorizeMenuItems(List<MenuItemModel> allMenuItems) {
    for (var item in allMenuItems) {
      if (!categorizedMenuItems.containsKey(item.category)) {
        categorizedMenuItems[item.category] = [];
      }
      categorizedMenuItems[item.category]!.add(item);
    }
  }

  void applyFilters() {
    filteredMenuByCategory.clear();

    for (var category in categorizedMenuItems.keys) {
      List<MenuItemModel> items = categorizedMenuItems[category] ?? [];

      if (isVegSelected.value && !isNonVegSelected.value) {
        items = items.where((item) => item.isVeg).toList();
      } else if (!isVegSelected.value && isNonVegSelected.value) {
        items = items.where((item) => !item.isVeg).toList();
      }

      // Assign the filtered items to the respective category
      filteredMenuByCategory[category] = items;
    }

    update();
  }

  // Retrieve the filtered items for display in the UI
  Map<String, List<MenuItemModel>> getFilteredMenuByCategory() {
    return filteredMenuByCategory;
  }

  void toggleVegFilter() {
    // Set vegSelected to true and nonVegSelected to false
    isVegSelected.value = true;
    isNonVegSelected.value = false;
    applyFilters(); // Reapply filters
  }

  void toggleNonVegFilter() {
    // Set nonVegSelected to true and vegSelected to false
    isNonVegSelected.value = true;
    isVegSelected.value = false;
    applyFilters(); // Reapply filters
  }

  void clearFilters() {
    // Reset both filters to show all items
    isVegSelected.value = false;
    isNonVegSelected.value = false;
    applyFilters(); // Reapply filters
  }
  //
  // MenuItemModel? getProductById(String productId) {
  //   try {
  //     return allMenuItems.firstWhere(
  //           (product) => product.id == productId,
  //     );
  //   } catch (e) {
  //     return null; // Return null if productId is not found
  //   }
  // }
}
