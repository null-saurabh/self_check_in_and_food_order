import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/menu_item_model.dart';
import '../../../../../widgets/widget_support.dart';
import '../../cart_screen/cart_screen_controller.dart';

class Count extends StatelessWidget {
  final MenuItemModel menuItem;

  const Count({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    // // Use GetX to find the CartScreenController
    // final CartScreenController cartController =
    //     Get.put(CartScreenController());

    return GetBuilder<CartScreenController>(
        init: CartScreenController(),
        builder: (cartScreenController) {
          return Obx(() {
            // Retrieve the current item count reactively
            int count = cartScreenController.getItemCount(menuItem.id);

            return Container(
              height: 36,
              width: 82,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff36DCA4)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: count > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                          
                                cartScreenController.decreaseItem(menuItem.id);
                          
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 20,
                              color: Color(0xffd0b84c),
                            ),
                          ),
                        ),
                        Text(
                          "$count",
                          style: const TextStyle(
                            color: Color(0xffd0b84c),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              cartScreenController.addItem(menuItem, 1);
                            },
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: Color(0xffd0b84c),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: InkWell(
                        onTap: () {
                          cartScreenController.addItem(menuItem, 1);
                        },
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "ADD",
                              style: AppWidget.subHeadingTextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ),
            );
          });
        });
  }
}
