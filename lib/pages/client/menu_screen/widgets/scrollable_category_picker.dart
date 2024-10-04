import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../menu_screen_controller.dart';

class ScrollableMenuCategoryPicker extends StatelessWidget {
  const ScrollableMenuCategoryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
    builder: (controller) {
    return SizedBox(
      height: 74,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_drop_up,size: 12,),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  // Only set starting index if it hasn't been set yet
                  if (!controller.hasStartedScrolling.value) {
                    double offset = controller.categoryPickerScrollController.offset;
                    controller.pickerStartingIndex.value = (offset / 20.0).round(); // Assuming item height is 20.0
                    // print("Starting picker: ${controller.pickerStartingIndex.value}");
                    controller.hasStartedScrolling.value = true; // Mark as started
                  }
                }

                if (scrollNotification is ScrollEndNotification || scrollNotification is UserScrollNotification) {
                  double offset = controller.categoryPickerScrollController.offset;
                  int index = (offset / 20.0).round(); // Assuming item height is 20.0

                  // Update the selected category index if it has changed
                  if (controller.selectedCategoryIndex.value != index) {
                    controller.selectCategory(index);
                    // Use the stored starting index for scrolling
                    // print("Starting picker 2: ${controller.pickerStartingIndex.value} : $index");

                    controller.scrollToCategory(index,MediaQuery.of(context).size.height * 0.75);
                  }
                }

                // // Reset the flag if scrolling has ended
                // if (scrollNotification is ScrollEndNotification) {
                //   print(4);
                //   hasStartedScrolling = false; // Allow starting a new scroll
                // }

                return true;
              },
              child: ListWheelScrollView.useDelegate(
                controller: controller.categoryPickerScrollController,
                itemExtent: 20, // The size of each category item
                // perspective: 0.01, // Optional 3D effect on the wheel
                // physics: const FixedExtentScrollPhysics(),
                // diameterRatio: 3.0, // Adjust to make the list less curved
                // onSelectedItemChanged: (index) {
                //   controller.selectCategory(index);
                //   controller.scrollToCategory(index);
                // },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: controller.filteredMenuByCategory.keys.length,
                  builder: (context, index) {
                    String category = controller.filteredMenuByCategory.keys.elementAt(index);
                    bool isSelected = controller.selectedCategoryIndex.value == index;

                    return Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: isSelected ? 16 : 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Icon(Icons.arrow_drop_down,size: 12),

        ],
      ),
    );
        });
  }
}
