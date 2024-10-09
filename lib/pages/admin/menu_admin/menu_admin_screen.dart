import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/menu_item_admin.dart';
import 'package:wandercrew/utils/routes.dart';
import 'menu_admin_controller.dart';

class MenuAdminScreen extends StatelessWidget {
  const MenuAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuAdminController>(
        init: MenuAdminController(),
        builder: (controller) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.bottomSheet(
                  AddFoodItem(),
                  isScrollControlled: true, // Allows the bottom sheet to expand with keyboard
                  backgroundColor: Color(0xffF4F5FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              shape: CircleBorder(),
            ),
            backgroundColor: const Color(0xffF4F5FA),
            appBar: AppBar(
              backgroundColor: const Color(0xffF4F5FA),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_outlined)),
              centerTitle: true,
              title: Text("Menu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          borderSide: BorderSide(color: Color(0xff36DCA4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xff36DCA4)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        // border: Border.all(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "MENU",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
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
                  ),
                ],
              ),
            ),
          );
        });
  }
}
