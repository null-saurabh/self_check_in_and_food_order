import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/menu_item_model.dart';

class MenuScreenController extends GetxController {
  RxBool isVegSelected = false.obs;
  RxBool isNonVegSelected = false.obs;

  Map<String, List<MenuItemModel>> categorizedMenuItems = {};
  RxList<MenuItemModel> allMenuItems = RxList.empty();

  // This will hold the filtered items for each category
  Map<String, List<MenuItemModel>> filteredMenuByCategory = {};

  RxList<bool> expandedCategories = RxList.empty();
  RxString receptionistText = "Welcome! Delicious Food Awaits You".obs;

  ScrollController listViewScrollController = ScrollController();
  ScrollController categoryPickerScrollController = ScrollController();

  List<GlobalKey> sectionKeys = [];

  RxInt selectedCategoryIndex = 0.obs;

  RxBool isScrollLocked = false.obs;



  void onListViewScroll() {

    if (isScrollLocked.value) {
      return; // Skip if scroll is locked
    }
    // Get the current scroll position
    // final offset = listViewScrollController.offset;

    for (int i = 0; i < sectionKeys.length; i++) {
      final key = sectionKeys[i];
      final context = key.currentContext;

      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox;
        final sectionTopPosition = renderBox.localToGlobal(Offset.zero).dy;

        // Correct the sectionTopPosition relative to the ListView's viewport
        final correctedPosition = sectionTopPosition - (Scaffold.of(context).appBarMaxHeight ?? 0) - 72;

        // If the section is approaching or touching the top of the ListView's viewport
        if (correctedPosition >= 0 && correctedPosition <= renderBox.size.height / 2) {
          if (selectedCategoryIndex.value != i) {

            isScrollLocked.value = true; // Start auto-scrolling

            selectedCategoryIndex.value = i;
            update();

            // Scroll the category picker to match the section
            categoryPickerScrollController.animateTo(
              i * 20.0, // Assuming each item in the picker has a fixed height of 24
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ).then((_) => isScrollLocked.value = false); // Reset after scroll complete;
          }
          break; // Once we find the section, exit the loop
        }
      }
    }
  }



  Map<int, double> sectionOffsets = {};
  Timer? _scrollDebounce;
// This function will be called every time a new section's offset is calculated
  void calculateSectionOffsets() {
    for (int i = 0; i < sectionKeys.length; i++) {
      final key = sectionKeys[i];
      final context = key.currentContext;

      if (context != null && !sectionOffsets.containsKey(i)) {
        final renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero).dy + listViewScrollController.offset - 228;

        sectionOffsets[i] = offset; // Cache the offset
      }
    }
  }

  void scrollToCategory(int index) {

    if (_scrollDebounce != null && _scrollDebounce!.isActive) {
      _scrollDebounce!.cancel();
    }

    isScrollLocked.value = true;
    calculateSectionOffsets();
    // Debounce the scroll action to avoid multiple triggers in a short time
    _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
      if (sectionOffsets.containsKey(index)) {
        // If we already have the offset for this section, scroll directly to it
        final offset = sectionOffsets[index]!;
        // print("Using cached offset: $offset");

        listViewScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) => isScrollLocked.value = false); // Reset after scroll complete;
      }
      else {
        // If the offset is not cached, scroll approximately to the right section
        // print("Scrolling approximately to section: $index");

        final approximateOffset = index * 300.0; // Estimate a rough offset
        listViewScrollController.animateTo(
          approximateOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) => isScrollLocked.value = false); // Reset after scroll complete;
      }
    });
  }




  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    update();
  }

  @override
  void onInit() {
    fetchMenuData();
    super.onInit();

    // Initialize the section keys based on the number of categories
    sectionKeys = List.generate(filteredMenuByCategory.keys.length, (index) => GlobalKey());

    // Add a listener for ListView scroll
    listViewScrollController.addListener(onListViewScroll);

  }

  fetchMenuData() async {
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Menu").get();
    allMenuItems.value = value.docs.map((element) => MenuItemModel.fromMap(element.data() as Map<String, dynamic>)).toList();

    categorizeMenuItems(allMenuItems);
    applyFilters(); // Apply filters initially
    initializeExpandedCategories(); // Initialize expanded categories

    update();
  }

  void categorizeMenuItems(List<MenuItemModel> allMenuItems) {
    // print("aaa");

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
      // print("apply");
      // print(filteredMenuByCategory[category] );
      sectionKeys = List.generate(filteredMenuByCategory.keys.length, (index) => GlobalKey());

    }

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

  // Initialize expanded categories based on the number of categories
  void initializeExpandedCategories() {
    expandedCategories.value = List.filled(filteredMenuByCategory.length, true); // True means expanded by default
  }

  void toggleCategoryExpansion(int index) {
    expandedCategories[index] = !expandedCategories[index];
    update();
  }
  @override
  void dispose() {
    listViewScrollController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    // Clean up the debounce timer when the controller is disposed
    _scrollDebounce?.cancel();
    super.onClose();
  }

}
