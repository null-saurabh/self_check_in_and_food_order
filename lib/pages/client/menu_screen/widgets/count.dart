import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/menu_item_model.dart';
import '../../../../../widgets/widget_support.dart';
import '../../cart_screen/cart_screen_controller.dart';

class Count extends StatelessWidget {
  final MenuItemModel menuItem;
  final bool isCart;
  final bool isDisabled;

  const Count({
    super.key,
    required this.menuItem,
    this.isCart = false,
    required this.isDisabled,
  });

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

            return Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 36,
                  width: 82,
                  decoration: BoxDecoration(
                    border: !isDisabled?Border.all(color: const Color(0xffEDCC23)):Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: count > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (!isDisabled) {
                                    cartScreenController
                                        .decreaseItem(menuItem.id);
                                  }
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
                                  if (!isDisabled) {
                                    cartScreenController.addItem(
                                        menuItem, 1, context);
                                  }
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
                              if (!isDisabled) {
                                cartScreenController.addItem(
                                    menuItem, 1, context);
                              }
                            },
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "ADD",
                                  style: !isDisabled?AppWidget.subHeadingTextStyle():AppWidget.subHeadingGreyTextStyle(),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                if (isCart)
                  Text(
                    '\u{20B9} ${menuItem.price * count}',
                    style: AppWidget.black14Text300Style(),
                  ),
              ],
            );
          });
        });
  }
}
