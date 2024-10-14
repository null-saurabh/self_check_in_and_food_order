import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/elevated_container.dart';
import '../menu_screen_controller.dart';

class VegFilterMenu extends StatelessWidget {
  const VegFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder: (controller) {
          return Obx(() {
            return ElevatedContainer(
              height: 60,
              child: Row(
                children: [
                  // Veg toggle button
                  GestureDetector(
                    onTap: () => controller.toggleVegFilter(),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: controller.isVegSelected.value
                            ? Colors.green
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 250),
                            left: controller.isVegSelected.value ? 22 : 4, // Adjust thumb position
                            top: 4,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Veg", style: TextStyle(fontSize: 16)),

                  SizedBox(width: 16),

                  // Non-Veg toggle button
                  GestureDetector(
                    onTap: () => controller.toggleNonVegFilter(),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: controller.isNonVegSelected.value
                            ? Colors.red
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 250),
                            left: controller.isNonVegSelected.value ? 22 : 4, // Adjust thumb position
                            top: 4,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Non-Veg", style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          });
        });
  }
}
