import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/menu_item_model.dart';

class MenuScreenController extends GetxController {


  @override
  void onInit() {
    fetchMenuData();
    super.onInit();

    // Initialize the section keys based on the number of categories
    sectionKeys = List.generate(filteredMenuByCategory.keys.length, (index) => GlobalKey());
    // Add a listener for ListView scroll
    listViewScrollController.addListener(onListViewScroll);

  }



  RxBool isVegSelected = false.obs;
  RxBool isNonVegSelected = false.obs;

  Map<String, List<MenuItemModel>> categorizedMenuItems = {};
  RxList<MenuItemModel> allMenuItems = RxList.empty();

  // This will hold the filtered items for each category
  Map<String, List<MenuItemModel>> filteredMenuByCategory = {};

  RxList<bool?> expandedCategories = RxList.empty();

  // RxList<bool> expandedCategories = RxList.empty();
  RxString receptionistText = "Welcome! Delicious Food Awaits You".obs;

  ScrollController listViewScrollController = ScrollController();
  ScrollController categoryPickerScrollController = ScrollController();
  RxInt pickerStartingIndex = RxInt(0);
  RxBool hasStartedScrolling = false.obs;


  List<GlobalKey> sectionKeys = [];

  RxInt selectedCategoryIndex = 0.obs;

  RxBool isScrollLocked = false.obs;

  var isLoading = true.obs; // Loading state


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

  List<Map<String, dynamic>> sortedCategories = [];




  fetchMenuData() async {
    try {
      isLoading.value = true; // Start loading

      // Fetch categories from "menu_category" collection and sort them by "id"
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection("Menu_Category")
          .orderBy("id") // Sort by "id" in ascending order
          .get();

      // Map the categories to a list
      sortedCategories = categorySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Fetch menu items where "isAvailable" is true
      QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
          .collection("Menu")
          .where("isAvailable", isEqualTo: true)
          .get();

      allMenuItems.value = menuSnapshot.docs
          .map((doc) =>
          MenuItemModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Categorize and sort the menu items based on the sorted categories
      categorizeMenuItems(allMenuItems, sortedCategories);
      applyFilters(); // Apply filters initially
      initializeExpandedCategories(); // Initialize expanded categories

      update();
    } catch (e) {
      debugPrint('Failed to fetch menu: $e');
    } finally {
      isLoading.value = false; // End loading
    }
  }

  void categorizeMenuItems(List<MenuItemModel> allMenuItems, List<Map<String, dynamic>> sortedCategories) {
    // Clear previous categories
    categorizedMenuItems.clear();

    // Iterate through sorted categories
    for (var category in sortedCategories) {
      String categoryName = category['categoryName'];

      // Filter menu items belonging to the current category
      List<MenuItemModel> items = allMenuItems
          .where((item) => item.category == categoryName)
          .toList();

    // Sort the items within the category by ascending "itemIndexNumber"
    items.sort((a, b) => a.itemIndexNumber.compareTo(b.itemIndexNumber));

      // Add the category to the map only if it has items
      if (items.isNotEmpty) {
        categorizedMenuItems[categoryName] = items;
      }
    }
  }

  // fetchMenuData() async {
  //   try {
  //     isLoading.value = true; // Start loading
  //     QuerySnapshot value = await FirebaseFirestore.instance.collection("Menu").where("isAvailable", isEqualTo: true).get();
  //     allMenuItems.value = value.docs.map((element) => MenuItemModel.fromMap(element.data() as Map<String, dynamic>)).toList();
  //
  //     categorizeMenuItems(allMenuItems);
  //     applyFilters(); // Apply filters initially
  //     initializeExpandedCategories(); // Initialize expanded categories
  //
  //     update();
  //   } catch (e) {
  //     debugPrint('Failed to fetch menu: $e');
  //
  //   }
  //   finally {
  //     isLoading.value = false; // End loading
  //   }
  // }
  //
  // void categorizeMenuItems(List<MenuItemModel> allMenuItems) {
  //   // print("aaa");
  //
  //   for (var item in allMenuItems) {
  //     if (!categorizedMenuItems.containsKey(item.category)) {
  //       categorizedMenuItems[item.category] = [];
  //     }
  //     categorizedMenuItems[item.category]!.add(item);
  //   }
  // }

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
      // print("apply");
      update();
    }
  }

  // Retrieve the filtered items for display in the UI
  Map<String, List<MenuItemModel>> getFilteredMenuByCategory() {
    return filteredMenuByCategory;
  }

  void toggleVegFilter() {
    if(isVegSelected.value == true){
      isVegSelected.value = false;
      applyFilters(); // Reapply filters
      return;
    }
    // Set vegSelected to true and nonVegSelected to false
    isVegSelected.value = true;
    isNonVegSelected.value = false;
    applyFilters(); // Reapply filters
  }

  void toggleNonVegFilter() {
    if(isNonVegSelected.value == true){
      isNonVegSelected.value = false;
      applyFilters(); // Reapply filters
      return;
    }
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

  // // Initialize expanded categories based on the number of categories
  // void initializeExpandedCategories() {
  //   expandedCategories.value = List.filled(filteredMenuByCategory.length, true); // True means expanded by default
  // }

  void initializeExpandedCategories() {
    expandedCategories.value = List.generate(filteredMenuByCategory.length, (index) {
      String categoryName = filteredMenuByCategory.keys.elementAt(index);
      List<Map<String, String>> availableTimes = getAvailableTimesForCategory(categoryName);

      // Check if availableTimes is not empty and pass the first element to isCategoryAvailable
      bool isAvailable = availableTimes.isNotEmpty ? isCategoryAvailable(availableTimes.first) : false;

      // If the category is available, expand it by default (true), else collapse it (false)
      return isAvailable;
    });
  }



  void toggleCategoryExpansion(int index) {
    // Toggle the category expansion on user interaction
    expandedCategories[index] = !expandedCategories[index]!;
    update();  // Update the UI with the new state
  }
  // void toggleCategoryExpansion(int index) {
  //   expandedCategories[index] = !expandedCategories[index]!;
  //   update();
  // }


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

  void scrollToCategory(int targetIndex,double approxScrollIncrement) {
    // Cancel any previous scroll requests
    if (_scrollDebounce != null && _scrollDebounce!.isActive) {
      _scrollDebounce!.cancel();
    }

    isScrollLocked.value = true;
    calculateSectionOffsets();

    int retryCount = 0; // Track the number of retries
    const int maxRetries = 10; // Maximum number of retries to avoid endless scrolling

    // Debounce the scroll action to avoid multiple triggers in a short time
    _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
      // Define a helper function to scroll incrementally
      void scrollIncrementally(int currentIndex) {
        // Check retry count to avoid endless scrolls
        if (retryCount > maxRetries) {
          // If exceeded max retries, stop the scrolling and log an error
          isScrollLocked.value = false;
          hasStartedScrolling.value = false;
          // print("Max retries reached, stopping scroll.");
          return;
        }

        if (currentIndex >= sectionKeys.length || currentIndex < 0) {
          // We've reached the end or start of the list
          isScrollLocked.value = false;
          hasStartedScrolling.value = false;
          return;
        }

        final context = sectionKeys[currentIndex].currentContext;

        if (context != null) {
          retryCount = 0; // Reset retries if we find a valid context
          final renderBox = context.findRenderObject() as RenderBox;
          final offset = renderBox.localToGlobal(Offset.zero).dy +
              listViewScrollController.offset - 228;

          // If we reach the target index, scroll to the exact offset
          if (currentIndex == targetIndex) {
            listViewScrollController.animateTo(
              offset,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            ).then((_) {
              hasStartedScrolling.value = false;
              isScrollLocked.value = false;
              // sayad return here;
            } );
          }
          else {
            // Scroll to the last known section and continue
            listViewScrollController.animateTo(
              offset,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            ).then((_) {
              // Check if we need to scroll up or down
              if (targetIndex > currentIndex) {
                // Scroll down
                scrollIncrementally(currentIndex + 1);

              } else if (targetIndex < currentIndex) {
                // Scroll up
                scrollIncrementally(currentIndex - 1);

              }
            });
          }
        }
        else {
          // If the context is still null, scroll by smaller increments
          retryCount++; // Increment the retry count

          // print("distance $approxScrollIncrement");
          double scrollIncrement = approxScrollIncrement;
          double maxScrollExtent = listViewScrollController.position.maxScrollExtent;
          double minScrollExtent = listViewScrollController.position.minScrollExtent;
          double currentScrollPosition = listViewScrollController.offset;
          double targetScrollPosition;

          if (targetIndex > pickerStartingIndex.value) {
            // print("scroll down (incremental) ${targetIndex} : ${pickerStartingIndex.value}");
            // Scrolling down
            targetScrollPosition = (currentScrollPosition + scrollIncrement) > maxScrollExtent
                ? maxScrollExtent
                : currentScrollPosition + scrollIncrement;
          } else {
            // print("scroll up (incremental) ${targetIndex} : ${pickerStartingIndex.value}");
            // Scrolling up
            targetScrollPosition = (currentScrollPosition - scrollIncrement) < minScrollExtent
                ? minScrollExtent
                : currentScrollPosition - scrollIncrement;
          }

          listViewScrollController.animateTo(
            targetScrollPosition,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          ).then((_) {
            scrollIncrementally(currentIndex); // Retry after scrolling by a smaller increment
          });
        }
      }

      // Start scrolling incrementally from the current section
      scrollIncrementally(selectedCategoryIndex.value);
    });
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    update();
  }




  bool isCategoryAvailable(Map<String, String> availableTime) {
    DateTime now = DateTime.now();
    String currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    String startTime = availableTime['start']!;
    String endTime = availableTime['end']!;

    return currentTime.compareTo(startTime) >= 0 && currentTime.compareTo(endTime) <= 0;
  }

  List<Map<String, String>> getAvailableTimesForCategory(String categoryName) {
    // Find the category with the given name
    var category = sortedCategories.firstWhere(
          (category) => category['categoryName'] == categoryName,
      orElse: () => {},  // Return an empty map if category is not found
    );

    // If the category is found, return the available times, otherwise return an empty list
    if (category.isNotEmpty) {
      // Safely cast the availableTimes list to the expected type
      List<Map<String, String>> availableTimes = List<Map<String, String>>.from(
        category['availableTimes'].map<Map<String, String>>((time) {
          // Ensure that each time map is casted properly
          return Map<String, String>.from(time);
        }).toList(),
      );
      return availableTimes;
    } else {
      return []; // Return empty list if category is not found
    }
  }



  String getNextAvailableTime(List<Map<String, String>> availableTimes, DateTime currentTime) {
    for (var timeRange in availableTimes) {
      // Parse start time to DateTime
      DateTime startTime = _parseTime(timeRange['start']!);

      // If the start time is after the current time, return it as the next available time
      if (startTime.isAfter(currentTime)) {
        return _formatTime(startTime); // Format the time before returning it
      }
    }

    return "N/A"; // Return "N/A" if no future time is available
  }

// Helper method to parse time string into DateTime
  DateTime _parseTime(String timeStr) {
    // Assume timeStr is in "HH:mm" format
    List<String> parts = timeStr.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hours, minutes);
  }

// Helper method to format DateTime back to "hh:mm a" (12-hour format with AM/PM)
  String _formatTime(DateTime time) {
    int hour = time.hour;
    String ampm = hour >= 12 ? "PM" : "AM";

    // Convert hour to 12-hour format (1-12 range)
    hour = hour % 12;
    if (hour == 0) hour = 12; // Handle 12:00 noon and midnight

    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $ampm";
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
