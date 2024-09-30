import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/expandable_menu_item.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/veg_filter.dart';
import '../../../widgets/widget_support.dart';
import '../cart_screen/cart_screen_controller.dart';
import 'menu_screen_controller.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder: (menuScreenController) {
          return Scaffold(
            backgroundColor: const Color(0xffF4F5FA),
            body: SingleChildScrollView(
                child: Container(
              margin: const EdgeInsets.only(top: 32.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.keyboard_backspace_rounded)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.toNamed('/admin/login');

                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminLogin()));
                          },
                          child: Text("Wander Crew,",
                              style: AppWidget.headingBoldTextStyle())),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/reception/menu/cart');
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
                        },
                        child: Stack(
                          children: [
                            Obx(() => Positioned(
                                  right: 10,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${Get.put(CartScreenController()).cartItems.length}', // Replace with your CartScreenController instance
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )),

                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            // Display cart item count
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text("Food Menu", style: AppWidget.subHeadingTextStyle()),
                  Text("Discover and Get Great Food",
                      style: AppWidget.black16Text400Style()),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: const VegFilterMenu(),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const ExpandableMenuItem(),
                ],
              ),
            )),
          );
        });
  }
}
