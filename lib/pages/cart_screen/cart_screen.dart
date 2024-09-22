import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/menu_item_model.dart';
import '../../service/razorpay_web.dart';
import '../../widgets/widget_support.dart';
import '../menu_screen/menu_screen_controller.dart';
import 'cart_screen_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuScreenController menuScreenController =
        Get.find<MenuScreenController>();

    return GetBuilder<CartScreenController>(
        init: CartScreenController(),
        builder: (cartScreenController) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                      elevation: 2.0,
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                              child: Text(
                            "Food Cart",
                            style: AppWidget.HeadlineTextFeildStyle(),
                          )))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: cartScreenController.cartItems.isEmpty
                          ? const Center(child: Text('Your cart is empty'))
                          : ListView.builder(
                              itemCount: cartScreenController.cartItems.length,
                              itemBuilder: (context, index) {
                                String productId = cartScreenController
                                    .cartItems.keys
                                    .elementAt(index);
                                int quantity =
                                    cartScreenController.cartItems[productId]!;
                                MenuItemModel? product = menuScreenController
                                    .getProductById(productId);
                                // Fetch additional product data as needed

                                if (product == null) {
                                  return const SizedBox(); // Skip if the product is not found
                                }

                                return ListTile(
                                  leading: product.image != null
                                      ? Image.network(
                                          product.image!,
                                          width: 65,
                                          height: 65,
                                        )
                                      : null,
                                  title: Text(product.name),
                                  subtitle: Text('Price: ${product.price}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          cartScreenController
                                              .decreaseItem(productId);
                                        },
                                      ),
                                      Text('$quantity'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          cartScreenController.addItem(
                                              productId, 1);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                  const Spacer(),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price",
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                        Text(
                          "\$${cartScreenController.total}",
                          style: AppWidget.semiBoldTextFeildStyle(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (cartScreenController.total > 0) {

                        RazorpayService razorpay = RazorpayService();
                        razorpay.openCheckout(
                            amount: cartScreenController.total.value * 100, key: "rzp_test_G05wrC5hbOAv5R",onSuccess: cartScreenController.onSuccess, onDismiss: cartScreenController.onDismiss, onFail: cartScreenController.onFail);
                      } else {}
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      child: const Center(
                          child: Text(
                        "CheckOut",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
