import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/single_product.dart';
import '../menu_screen_controller.dart';

class ExpandableMenuItem extends StatelessWidget {
  const ExpandableMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder:(controller) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling for parent list
            shrinkWrap: true, // Allow the ListView to take only the necessary height
            children: controller.filteredMenuByCategory.entries
                .where((entry) => entry.value.isNotEmpty) // Filter out empty categories
                .map((entry) {
              int index = controller.filteredMenuByCategory.keys.toList().indexOf(entry.key);
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.toggleCategoryExpansion(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        border: const Border(bottom: BorderSide.none,),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            controller.expandedCategories[index]
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.expandedCategories[index]) ...[ // Show items only if expanded
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.2),
                          //     spreadRadius: 1,
                          //     blurRadius: 5,
                          //   ),
                          // ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: entry.value.map((menuItem) {
                            return SingleProduct(menuItem: menuItem);
                          }).toList(),
                        ),
                      ),
                    ),]
                ],
              );
            }).toList(),
          );
        }
    );
  }
}
