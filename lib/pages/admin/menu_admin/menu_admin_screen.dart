import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/filter_menu_list_admin.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/menu_item_admin.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/widget_support.dart';
import 'menu_admin_controller.dart';

class MenuAdminScreen extends StatelessWidget {
  const MenuAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuAdminController>(
        init: MenuAdminController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: const Color(0xffFFFEF9),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 46, bottom: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GoRouter.of(context).canPop()
                                ? IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                  context.pop(); // Go back if there's a previous route

                              },
                            ):const SizedBox.shrink(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Manage',
                                  style: AppWidget.black24Text600Style()
                                      .copyWith(height: 1),
                                ),
                                Text(
                                  'Menu',
                                  style: AppWidget.black24Text600Style(
                                      color: const Color(0xffE7C64E))
                                      .copyWith(height: 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20,bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height:40,
                                  child: TextField(
                                    onChanged: (value) => controller
                                        .searchFilterMenuItems(value), // Call the search function
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "Search by item name",
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xffEDCC23)),//(0xffEDCC23)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                        const BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4,),
                              AppElevatedButton(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                width: 40,
                                showBorder: true,
                                backgroundColor: Colors.transparent,
                                borderColor: const Color(0xffEDCC23),
                                borderWidth: 1,
                                titleTextColor: Colors.black,
                                child: const Icon(Icons.add,color: Colors.black,size: 20,),
                                onPressed: (){

                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true, // Allows the bottom sheet to expand with the keyboard
                                    backgroundColor: const Color(0xffF4F5FA),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    builder: (context) {
                                      return const AddFoodItem(); // Your widget for the bottom sheet
                                    },
                                  );

                                  // Get.bottomSheet(
                                  //   const AddFoodItem(),
                                  //   isScrollControlled: true, // Allows the bottom sheet to expand with keyboard
                                  //   backgroundColor: const Color(0xffF4F5FA),
                                  //   shape: const RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  //   ),
                                  // );
                                },
                              ),
                              const SizedBox(width: 4,),
                              Stack(
                                children: [
                                  Obx(() {
                                    // Count active filters (based on your filter logic)
                                    int activeFiltersCount = 0;

                                    // Check for item price filters
                                    if (controller.filterMinItemPrice.text.isNotEmpty) activeFiltersCount++;
                                    if (controller.filterMaxItemPrice.text.isNotEmpty) activeFiltersCount++;

                                    // Check for other filters (Veg and Availability)
                                    if (controller.selectedVegFilter.value != null) activeFiltersCount++;
                                    if (controller.selectedAvailableFilter.value != null) activeFiltersCount++;

                                    // Only show the circle if there are active filters
                                    if (activeFiltersCount > 0) {
                                      return Positioned(
                                        right: 4,  // Adjust this to position it properly
                                        top: -2,    // Adjust this to position it properly
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              activeFiltersCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink(); // Return empty widget if no filters are active
                                    }
                                  }),
                                  AppElevatedButton(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 40,
                                    showBorder: true,
                                    backgroundColor: Colors.transparent,
                                    borderColor: const Color(0xffEDCC23),
                                    borderWidth: 1,
                                    titleTextColor: Colors.black,
                                    child: const Icon(Icons.filter_alt, color: Colors.black, size: 22),

                                      onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const FilterMenuListAdmin();
                                          }
                                      );
                                    },
                                  ),


                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.allMenuItems.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 16),
                        itemCount: controller.allMenuItems.length,
                        itemBuilder: (context, index) {
                          // print("${controller.allMenuItems[index].name} : ${controller.allMenuItems[index].id}");
                          return MenuItemWidget(
                            menuItem: controller.allMenuItems[index],
                            onEdit: () => controller.editMenuItem(context,
                                controller.allMenuItems[index]),
                            onDelete: () => controller.deleteMenuItem(
                                context,
                                controller.allMenuItems[index]),
                            onToggleAvailability: (isAvailable) =>
                                controller.toggleAvailability(context,
                                    controller.allMenuItems[index],
                                    isAvailable),
                            onEditPrice: () =>
                                controller.editMenuItemPrice(context,
                                    controller.allMenuItems[index]),
                            onEditNote: () =>
                                controller.editMenuItemNote(context,
                                    controller.allMenuItems[index]),
                          );
                        },
                      ),
                    );
                  } else if (controller.isLoading.value) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    return const Expanded(
                        child: Center(child: Text("No orders found.")));
                  }
                }),

              ],
            ),
          );
        });
  }
}
