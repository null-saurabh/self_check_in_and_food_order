import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../menu_screen_controller.dart';

class VegFilterMenu extends StatelessWidget {
  const VegFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder:(controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() {
                return GestureDetector(
                onTap: () => controller.toggleVegFilter(),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.isVegSelected.value ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/images/ice-cream.png",
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      color: controller.isVegSelected.value ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );}),
              const SizedBox(width: 20),
              Obx(() {
                return GestureDetector(
                onTap: () => controller.toggleNonVegFilter(),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.isNonVegSelected.value ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/images/pizza.png",
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      color: controller.isNonVegSelected.value ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );}),
            ],
          );
        }
    );
  }
}
