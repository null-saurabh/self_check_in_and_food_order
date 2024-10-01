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
          Icon(Icons.arrow_drop_up,size: 12,),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 20, // The size of each category item
              perspective: 0.01, // Optional 3D effect on the wheel
              physics: const FixedExtentScrollPhysics(),
              diameterRatio: 3.0, // Adjust to make the list less curved
              onSelectedItemChanged: (index) {
                controller.selectCategory(index);
              },
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
          Icon(Icons.arrow_drop_down,size: 12),
      
        ],
      ),
    );
        });
  }
}
