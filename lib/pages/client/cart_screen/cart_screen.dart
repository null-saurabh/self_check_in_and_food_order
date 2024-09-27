import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/cart_model.dart';
import '../../../models/menu_item_model.dart';
import '../../../widgets/widget_support.dart';
import 'cart_screen_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        style: AppWidget.headingBoldTextStyle(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: cartScreenController.cartItems.isEmpty
                      ? const Center(child: Text('Your cart is empty'))
                      : ListView.builder(
                          itemCount: cartScreenController.cartItems.length,
                          itemBuilder: (context, index) {
                            String menuItemId = cartScreenController
                                .cartItems.keys
                                .elementAt(index);

                            CartItemModel cartItem = cartScreenController.cartItems[menuItemId]!;
                            MenuItemModel menuItem = cartItem.menuItem;

                            return ListTile(
                              leading: menuItem.image != null
                                  ? Image.network(
                                      menuItem.image!,
                                      width: 65,
                                      height: 65,
                                    )
                                  : null,
                              title: Text(menuItem.name),
                              subtitle: Text('Price: ${menuItem.price}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      cartScreenController
                                          .decreaseItem(menuItemId);
                                    },
                                  ),
                                  Text(
                                      '${cartScreenController.getItemCount(menuItemId)}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      cartScreenController.addItem(menuItem, 1);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const Spacer(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                      Text(
                        "\$${cartScreenController.totalAmount.value.toStringAsFixed(2)}", // Update to totalAmount
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () async {
                    if (cartScreenController.totalAmount.value > 0) {
                      await cartScreenController.initiatePayment();
                    } else {
                      Get.snackbar("Error", "Your cart is empty.");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: const Center(
                      child: Text(
                        "CheckOut",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
