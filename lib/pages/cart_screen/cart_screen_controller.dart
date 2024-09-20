import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../menu_screen/menu_screen_controller.dart';

class CartScreenController extends GetxController {

  RxInt total = 0.obs;


  Future<void> onSuccess(response) async {
    try {
      final MenuScreenController menuScreenController = Get.find<MenuScreenController>();

      // Get today's date
      String todayDate = DateTime.now().toIso8601String();

      // Generate the order name from cart items
      String orderName = "";
      cartItems.forEach((productId, quantity) {
        ProductModel? product = menuScreenController.getProductById(productId);
        if (product != null) {
          orderName += "${product.productName}($quantity), ";
        }
      });

      // Remove trailing comma and space
      if (orderName.isNotEmpty) {
        orderName = orderName.substring(0, orderName.length - 2);
      }

      // Create the order map to store in Firebase
      Map<String, dynamic> orderData = {
        "orderName": orderName,
        "amount": total.value,
        "date": todayDate,
      };

      // Add the order to Firebase
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // Clear the cart after successful payment
      clearCart();

      // Display a success message
      Get.snackbar(
        "Success",
        "Order placed successfully!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Handle any errors that occur during the order process
      Get.snackbar(
        "Error",
        "Failed to place the order. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Future<void> onSuccess(response) async {
  //
  //   final cartProvider = Provider.of<CartProvider>(context, listen: false);
  //   final productProvider = Provider.of<ProductProvider>(context, listen: false);
  //
  //   Get today's date
  //   String todayDate = DateTime.now().toIso8601String();
  //
  //   Generate the order name from cart items
  //   String orderName = "";
  //   cartProvider.cartItems.forEach((productId, quantity) {
  //     ProductModel? product = productProvider.getProductById(productId);
  //     if (product != null) {
  //       orderName += "${product.productName}(${quantity}), ";
  //     }
  //   });
  //
  //   // Remove trailing comma and space
  //   if (orderName.isNotEmpty) {
  //     orderName = orderName.substring(0, orderName.length - 2);
  //   }
  //
  //   // Create the order map
  //   Map<String, dynamic> orderData = {
  //     "orderName": orderName,
  //     "amount": total,
  //     "date": todayDate,
  //   };
  //
  //   // Add the order to Firebase
  //   await DatabaseMethods().addOrder(orderData);
  //
  //   // Optionally, clear the cart after successful payment
  //   cartProvider.clearCart();
  //
  //   Display a success message (optional)
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text("Order placed successfully!"),
  //   ));
  //
  //
  // }

  void onFail(response) {

  }

  void onDismiss(response) {

  }


  var cartItems = <String, int>{}.obs; // Using a reactive map to store product ID and quantity

  // Add item to cart or update quantity if it already exists
  void addItem(String productId, int quantity) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId] = cartItems[productId]! + quantity;
    } else {
      cartItems[productId] = quantity;
    }
    calculateTotalAmount(); // Calculate total after updating
    update();
  }

  // Remove item from cart
  void removeItem(String productId) {
    cartItems.remove(productId);
    calculateTotalAmount();
  }

  // Decrease item quantity or remove it if quantity is 0
  void decreaseItem(String productId) {
    if (cartItems.containsKey(productId) && cartItems[productId]! > 1) {
      cartItems[productId] = cartItems[productId]! - 1;
    } else {
      cartItems.remove(productId); // Remove item if the quantity is 1 and it gets decremented
    }
    calculateTotalAmount(); // Calculate total after updating
    update();
  }

  void calculateTotalAmount() {
    final MenuScreenController menuScreenController = Get.find<MenuScreenController>();
    int tempTotal = 0;

    cartItems.forEach((productId, quantity) {
      ProductModel? product = menuScreenController.getProductById(productId);
      if (product != null) {
        tempTotal += int.parse(product.productPrice) * quantity;
      }
    });

    total.value = tempTotal; // Update the total
  }

  // Clear all items from the cart
  void clearCart() {
    cartItems.clear();
    total.value  = 0;
  }

  // Get item count
  int getItemCount(String productId) {
    return cartItems[productId] ?? 0;
  }

  // Get total items in the cart (counts how many different products are in the cart)
  int get totalItems => cartItems.length;

  // Get total quantity of all items in the cart
  int get totalQuantity => cartItems.values.fold(0, (sums, quantity) => sums + quantity);
}
