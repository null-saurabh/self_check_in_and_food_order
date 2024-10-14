import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/filter_button.dart';
import '../../../../widgets/widget_support.dart';
import '../cart_screen_controller.dart';

class CartTipWidget extends StatelessWidget {
  const CartTipWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartScreenController>(
      init: CartScreenController(),
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Obx(() {
                        CartScreenController controller =
                            Get.find<CartScreenController>();
                        return Checkbox(
                          value: controller.isTipSelected
                              .value, // Boolean value to handle selection
                          onChanged: (bool? value) {
                            // Handle the selection change
                            controller.isTipSelected.value = value!;
                            if (!controller.isTipSelected.value) {
                              controller.tipAmount.value = 0;
                            }
                          },
                          shape:
                              const CircleBorder(), // Making the checkbox circular
                          activeColor: const Color(
                              0xffE7C64E), // Active color when selected
                        );
                      }),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Donate to Wander Crew Team",
                            style: AppWidget.black16Text500Style(),
                          ),
                          Text(
                            "Support us to improve ourself.",
                            style: AppWidget.black12Text500Style(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Obx(() {
                    if (controller.isTipSelected.value)
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 40),
                        child: Row(
                          children: [
                            FilterButton(
                              selectedTextStyle: AppWidget.black14Text600Style(),
                              notSelectedTextStyle:
                                  AppWidget.black14Text400Style(),
                              label: "10",
                              isSelected: controller.tipAmount.value == 10,
                              onTap: () {
                                controller.tipAmount.value = 10;
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            FilterButton(
                              selectedTextStyle: AppWidget.black14Text600Style(),
                              notSelectedTextStyle:
                                  AppWidget.black14Text400Style(),
                              label: "20",
                              isSelected: controller.tipAmount.value == 20,
                              onTap: () {
                                controller.tipAmount.value = 20;
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            FilterButton(
                              selectedTextStyle: AppWidget.black14Text600Style(),
                              notSelectedTextStyle:
                                  AppWidget.black14Text400Style(),
                              label: "50",
                              isSelected: controller.tipAmount.value == 50,
                              onTap: () {
                                controller.tipAmount.value = 50;
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            FilterButton(
                              selectedTextStyle: AppWidget.black14Text600Style(),
                              notSelectedTextStyle:
                                  AppWidget.black14Text400Style(),
                              label: "100",
                              isSelected: controller.tipAmount.value == 100,
                              onTap: () {
                                controller.tipAmount.value = 100;
                              },
                            ),
                          ],
                        ),
                      );
                    else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              )),
        );
      },
    );
  }
}
