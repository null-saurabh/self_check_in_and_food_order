import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/single_product.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/veg_filter.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../menu_screen_controller.dart';

class ExpandableMenuItem extends StatelessWidget {
  const ExpandableMenuItem({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder:(controller) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.92,
              // height: MediaQuery.of(context).size.height * 0.95,

              // padding: const EdgeInsets.only(left: 0, right: 6, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: controller.filteredMenuByCategory.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  :Column(
                    children: [
                      VegFilterMenu(),
                      SizedBox(height: 12,),
                      Expanded(
                        child: ListView(
                                        controller: controller.listViewScrollController,
                                        shrinkWrap: true, // Allow the ListView to take only the necessary height
                                        children: controller.filteredMenuByCategory.entries
                          .where((entry) => entry.value.isNotEmpty) // Filter out empty categories
                          .map((entry) {
                        int index = controller.filteredMenuByCategory.keys.toList().indexOf(entry.key);
                        return Column(
                          key: controller.sectionKeys[index],
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
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Container(
                                  height: 52,
                                  // width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 10,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffEDCC23), // Yellow left border
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12), // Match outer corner radius
                                            bottomLeft: Radius.circular(12), // Match outer corner radius
                                          ),
                                        ),
                                      ),
                                      Text(
                                        entry.key,
                                        style: AppWidget.heading24Bold500TextStyle(),
                                      ),
                                      Icon(
                                        controller.expandedCategories[index]
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_drop_up,
                                      ),
                                    ],
                                  ),
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
                                  padding: const EdgeInsets.all(8),
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
                                      ),
                      ),
                    ],
                  ),
            ),
          );
        }
    );
  }
}
