import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';
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
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Get.back(),
                            ),
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
                                      color: Color(0xffE7C64E))
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
                                        .filterMenuItems(value), // Call the search function
                                    decoration: InputDecoration(
                                      hintText: "Search by item name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xffEDCC23)),//(0xffEDCC23)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                        BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4,),
                              AppElevatedButton(
                                showBorder: true,
                                backgroundColor: Colors.transparent,
                                borderColor: Color(0xffEDCC23),
                                borderWidth: 1,
                                titleTextColor: Colors.black,
                                title: "Add User",
                                onPressed: (){
                                  Get.bottomSheet(
                                    AddFoodItem(),
                                    isScrollControlled: true, // Allows the bottom sheet to expand with keyboard
                                    backgroundColor: Color(0xffF4F5FA),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                  );
                                },
                              )
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
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8, bottom: 16),

                          // padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: controller.allMenuItems.length,
                                  itemBuilder: (context, index) {
                                    return MenuItemWidget(
                                      menuItem: controller.allMenuItems[index],
                                      onEdit: () => controller.editMenuItem(
                                          controller.allMenuItems[index]),
                                      onDelete: () => controller.deleteMenuItem(
                                          controller.allMenuItems[index]),
                                      onToggleAvailability: (isAvailable) =>
                                          controller.toggleAvailability(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (controller.isLoading.value) {
                    return Expanded(
                        child: const Center(child: CircularProgressIndicator()));
                  } else {
                    return Expanded(
                        child: const Center(child: Text("No orders found.")));
                  }
                }),

              ],
            ),
          );
        });
  }
}
