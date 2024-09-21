import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/widget_support.dart';
import '../../cart_screen/cart_screen_controller.dart';

class Count extends StatelessWidget {
  final String productName;
  final String productImage;
  final String productId;
  final String productPrice;

  const Count({
    super.key,
    required this.productName,
    required this.productId,
    required this.productImage,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    // Use GetX to find the CartScreenController
    final CartScreenController cartController =
        Get.put(CartScreenController());

    return Obx(() {
      // Retrieve the current item count reactively
      int count = cartController.getItemCount(productId);

      return Container(
        height: 35,
        width: 75,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: count > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (count == 1) {
                        cartController.removeItem(productId);
                      } else {
                        cartController.decreaseItem(productId);
                      }
                    },
                    child: const Icon(
                      Icons.remove,
                      size: 20,
                      color: Color(0xffd0b84c),
                    ),
                  ),
                  Text(
                    "$count",
                    style: const TextStyle(
                      color: Color(0xffd0b84c),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cartController.addItem(productId, 1);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xffd0b84c),
                    ),
                  ),
                ],
              )
            : Center(
                child: InkWell(
                  onTap: () {
                    cartController.addItem(productId, 1);
                  },
                  child: Text(
                    "ADD",
                    style: AppWidget.LightTextFeildStyle(),
                  ),
                ),
              ),
      );
    });
  }
}
