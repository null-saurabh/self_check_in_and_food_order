import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

import '../../models/cart_model.dart';
import '../../models/menu_item_model.dart';
import '../../models/order_model.dart';
import '../../service/razorpay_web.dart';

class CartScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchRazorpayKey();
  }

  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController dinerName = TextEditingController();

  RxDouble totalAmount = 0.0.obs;
  var cartItems = <String, CartItemModel>{}
      .obs; // Key is menuItemID, value is CartItemModel
  String razorpayKey = ""; // Variable to hold the Razorpay key

  Future<void> onSuccess(response) async {
    try {
      print('aaa');
      // String paymentStatus = response['status']; // From Razorpay response
      // String paymentMethod = response['method']; // From Razorpay response
      String transactionID =
          response['paymentId']; // From Razorpay response

      print('aaaa');
      print(transactionID);

      // Get today's date
      String todayDate = DateTime.now().toIso8601String();

      // Create a list of OrderedItemModels from cart items
      List<OrderedItemModel> orderedItems = cartItems.entries.map((entry) {
        return OrderedItemModel(
          menuItemId: entry.value.menuItem.id,
          menuItemName: entry.value.menuItem.name,
          quantity: entry.value.quantity,
          price: entry.value.menuItem.price,
        );
      }).toList();

      String addId = randomAlphaNumeric(10);

      // Create order model
      OrderModel orderData = OrderModel(
        orderId: addId, // Firebase will generate the ID
        transactionId: transactionID,
        dinerName: "kk", //dinerName.text,
        orderStatusHistory: [
          OrderStatusUpdate(
              status: "Pending",
              updatedTime: DateTime.now(),
              updatedBy: "System")
        ],
        items: orderedItems,
        totalAmount: 11,//totalAmount.value,
        paymentMethod: "", // Or other payment methods
        orderDate: todayDate,
        deliveryAddress:
        "kk", //deliveryAddressController.text, // Replace with dynamic data
        contactNumber:
        "kk", //contactNumberController.text, // Replace with dynamic data
        estimatedDeliveryTime: "30 mins", // Dynamically adjust
        paymentStatus: "",
      );

// Add the order to Firebase
      await FirebaseFirestore.instance
          .collection('orders')
          .add(orderData.toMap());

      clearCart();
      Get.snackbar("Success", "Order placed successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Handle any errors that occur during the order process
      print(e);
      print("aaaaaaa");
      Get.snackbar(
        "Error",
        "Payment Complete!, But Failed to place the order. Contact Staff.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Handle payment failure
  void onFail(response) {
    Get.snackbar("Payment Failed", "${response['message']} Please try again.",
        snackPosition: SnackPosition.BOTTOM);
  }

  void onDismiss(response) {
    Get.snackbar("Payment Dismissed!", "${response['message']} Please try again.",
        snackPosition: SnackPosition.BOTTOM);
  }

  // Add item to cart or update quantity
  void addItem(MenuItemModel menuItem, int quantity) {
    if (cartItems.containsKey(menuItem.id)) {
      cartItems[menuItem.id]!.quantity += quantity;
    } else {
      cartItems[menuItem.id] =
          CartItemModel(menuItem: menuItem, quantity: quantity);
    }
    calculateTotalAmount();
    update();
  }

// // Remove item from cart
//   void removeItem(String productId) {
//     cartItems.remove(productId);
//     calculateTotalAmount();
//   }

  // Decrease item quantity
  void decreaseItem(String menuItemId) {
    if (cartItems.containsKey(menuItemId)) {
      if (cartItems[menuItemId]!.quantity > 1) {
        cartItems[menuItemId]!.quantity -= 1;
      } else {
        cartItems.remove(menuItemId);
      }
    }
    calculateTotalAmount();
    update();
  }

  // Calculate total amount of the cart
  void calculateTotalAmount() {
    double tempTotal = 0.0;
    cartItems.forEach((key, cartItem) {
      tempTotal += cartItem.totalPrice;
    });
    totalAmount.value = tempTotal;
  }

  // Clear all items from the cart
  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
  }

  Future<void> initiatePayment() async {
    if (totalAmount > 0) {
      if (razorpayKey.isNotEmpty) {
        // Check if the key is valid
        RazorpayService razorpay = RazorpayService();
        razorpay.openCheckout(
          amount: (totalAmount.value * 100).toInt(),
          key: razorpayKey,
          onSuccess: onSuccess,
          onDismiss: onDismiss,
          onFail: onFail,
        );
      } else {
        Get.snackbar(
            "Error", "Razorpay is not available. Please Contact Wander Team.");
      }
    } else {
      Get.snackbar("Error", "Total amount must be greater than zero.");
    }
  }

  // Get the quantity of a specific item in the cart
  int getItemCount(String productId) {
    return cartItems.containsKey(productId)
        ? cartItems[productId]!.quantity
        : 0;
  }

  // Get total quantity of all items in the cart
  int get totalQuantity =>
      cartItems.values.fold(0, (sums, item) => sums + item.quantity);

  Future<void> fetchRazorpayKey() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Razorpay")
          .doc("i1m8ZJztxSYL35B7rboh")
          .get();

      if (snapshot.exists) {
        razorpayKey = snapshot.get("testKey");
      } else {
        Get.snackbar("Error", "Razorpay key not found");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch Razorpay key: $e");
    }
  }
}
