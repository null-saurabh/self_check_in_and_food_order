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
  RxInt pickerStartingIndex = RxInt(0);
  RxBool hasStartedScrolling = false.obs;


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



  // void scrollToCategory(int targetIndex) {
  //   // Cancel any previous scroll requests
  //   if (_scrollDebounce != null && _scrollDebounce!.isActive) {
  //     _scrollDebounce!.cancel();
  //   }
  //
  //   isScrollLocked.value = true;
  //   calculateSectionOffsets();
  //
  //   int retryCount = 0; // Track the number of retries
  //   const int maxRetries = 25; // Maximum number of retries to avoid endless scrolling
  //
  //   // Debounce the scroll action to avoid multiple triggers in a short time
  //   _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
  //     // Define a helper function to scroll incrementally
  //     void scrollIncrementally(int currentIndex) {
  //       // print("in scroll $currentIndex, $targetIndex");
  //       // Check retry count to avoid endless scrolls
  //       if (retryCount > maxRetries) {
  //         // If exceeded max retries, stop the scrolling and log an error
  //         isScrollLocked.value = false;
  //         // print("Max retries reached, stopping scroll.");
  //         return;
  //       }
  //
  //       // Check bounds for currentIndex
  //       if (currentIndex >= sectionKeys.length || currentIndex < 0) {
  //         // We've reached the end or start of the list
  //         isScrollLocked.value = false;
  //         return;
  //       }
  //
  //       final context = sectionKeys[currentIndex].currentContext;
  //
  //       if (context != null) {
  //         retryCount = 0; // Reset retries if we find a valid context
  //         final renderBox = context.findRenderObject() as RenderBox;
  //         final offset = renderBox.localToGlobal(Offset.zero).dy +
  //             listViewScrollController.offset - 228;
  //
  //         // Scroll to the exact offset of the current section
  //         listViewScrollController.animateTo(
  //           offset,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeInOut,
  //         ).then((_) {
  //           // After scrolling, check if we've reached the target index
  //           if (currentIndex == targetIndex) {
  //             // If we reach the target, stop scrolling
  //             isScrollLocked.value = false;
  //             // print("Reached target index: $targetIndex");
  //           } else {
  //             // Check direction and update index
  //             if (targetIndex > currentIndex) {
  //               // print("scroll down ${targetIndex} : ${currentIndex}");
  //               scrollIncrementally(currentIndex + 1); // Scroll down
  //             } else if (targetIndex < currentIndex) {
  //               // print("scroll up ${targetIndex} : ${currentIndex}");
  //               scrollIncrementally(currentIndex - 1); // Scroll up
  //             }
  //           }
  //         });
  //       } else {
  //         // If the context is still null, scroll by smaller increments
  //         retryCount++; // Increment the retry count
  //
  //         const double scrollIncrement = 200.0; // Use smaller increments
  //         double maxScrollExtent = listViewScrollController.position.maxScrollExtent;
  //         double minScrollExtent = listViewScrollController.position.minScrollExtent;
  //         double currentScrollPosition = listViewScrollController.offset;
  //         double targetScrollPosition;
  //
  //         // Determine the target scroll position based on direction
  //         if (targetIndex > currentIndex) {
  //           // Scrolling down
  //           print("scroll down (incremental) ${targetIndex} : ${currentIndex}");
  //           targetScrollPosition = (currentScrollPosition + scrollIncrement) > maxScrollExtent
  //               ? maxScrollExtent
  //               : currentScrollPosition + scrollIncrement;
  //         } else {
  //           // Scrolling up
  //           print("scroll up (incremental) ${targetIndex} : ${currentIndex}");
  //           targetScrollPosition = (currentScrollPosition - scrollIncrement) < minScrollExtent
  //               ? minScrollExtent
  //               : currentScrollPosition - scrollIncrement;
  //         }
  //
  //         listViewScrollController.animateTo(
  //           targetScrollPosition,
  //           duration: const Duration(milliseconds: 200),
  //           curve: Curves.easeInOut,
  //         ).then((_) {
  //           // Retry after scrolling by a smaller increment
  //           scrollIncrementally(pickerStartingIndex.value!);
  //         });
  //       }
  //     }
  //
  //     print("starting scroll increment: ${pickerStartingIndex.value}");
  //     // Start from the selected category index
  //     scrollIncrementally(pickerStartingIndex.value);
  //   });
  // }













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
          print("Max retries reached, stopping scroll.");
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

          print("distance $approxScrollIncrement");
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
