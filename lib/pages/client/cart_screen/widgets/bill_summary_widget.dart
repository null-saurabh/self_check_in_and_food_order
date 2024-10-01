import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/cart_screen/widgets/row_item_widget.dart';
import '../../../../widgets/widget_support.dart';
import '../cart_screen_controller.dart';
import 'apply_coupon_widget.dart';

class CartBillSummaryWidget extends StatelessWidget {
  const CartBillSummaryWidget({
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
              child: Obx(() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bill Summary",
                      style: AppWidget.black16Text600Style(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CartRowItemWidget(
                      label: "Item Total",
                      amount: controller.itemTotalAmount.value,
                    ),
                    CartRowItemWidget(
                      label: "Tax And Other Charges",
                      amount: controller.taxChargesAmount.value,
                    ),
                    if (controller.tipAmount.value != null)
                      CartRowItemWidget(
                          label: "Tip", amount: controller.tipAmount.value!),
                    if (controller.isPromoApplied.value)
                      CartRowItemWidget(
                        label: 'Coupon (${controller.promoCode.value!.code})',
                        amount: controller.promoCode.value!.discount,
                        isCoupon: true,
                        onPressed: controller.removePromoCode,
                      ),
                    if (!controller.isPromoWidgetVisible.value &&
                        !controller.isPromoApplied.value)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                controller.isPromoWidgetVisible.value = true;
                              },
                              child: Text(
                                "Coupon Code",
                                style: AppWidget.grey12Light400TextStyle(),
                              )),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.red,
                            size: 16,
                          ),
                        ],
                      ),
                    if (controller.isPromoWidgetVisible.value) ...[
                      const SizedBox(height: 8),
                      Form(
                        key: controller.cartFormKey,
                        child: ApplyCouponWidget(
                            promoCode: controller.promoCodeController,
                            onPressed: (code) {
                              return controller.applyPromoCode(code);
                            }),
                      ),
                    ],
                    const SizedBox(
                      height: 12,
                    ),
                    CartRowItemWidget(
                      label: "Grand Total",
                      amount: controller.grandTotal.value,
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}