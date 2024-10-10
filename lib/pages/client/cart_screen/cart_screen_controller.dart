import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

import '../../../models/cart_model.dart';
import '../../../models/menu_item_model.dart';
import '../../../models/order_model.dart';
import '../../../models/promo_code_model.dart';
import '../../../service/database.dart';
import '../../../service/razorpay_web.dart';
import 'package:http/http.dart' as http;



class CartScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    calculateTipAmount;
    fetchRazorpayKey();
    fetchCountryCodes(); // Fetch countries from API when controller is initialized

    // Listen to any changes in relevant fields and recalculate the grand total
    everAll([itemTotalAmount, taxChargesAmount, tipAmount, isPromoApplied], (_) {
      calculateGrandTotal();
    });

    dinerName.addListener(_updateButtonState);
    contactNumberController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    update(); // This triggers the widget to rebuild when text changes
  }

  final GlobalKey<FormState> cartFormKey= GlobalKey<FormState>();
  final GlobalKey<FormState> cartDinnerInfoFormKey= GlobalKey<FormState>();

  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  TextEditingController dinerName = TextEditingController();

  TextEditingController promoCodeController = TextEditingController();
  Rxn<PromoCodeModel> promoCode = Rxn<PromoCodeModel>();

  List<PromoCodeModel> promoList = [
    PromoCodeModel(code: 'DISCOUNT10', discount: 50),
    PromoCodeModel(code: 'SAVE20', discount: 100),
  ];

  RxBool isPromoApplied = false.obs;
  RxBool isPromoWidgetVisible = false.obs;


  RxString receptionistText = "Your Cart is Empty".obs;
  RxBool isTipSelected  = true.obs;


  RxDouble itemTotalAmount = 0.0.obs;
  RxDouble taxChargesAmount = 0.0.obs;

  var tipPercentage = 5.obs; // Percentage of tip selected, default to 0
  RxnDouble tipAmount = RxnDouble(); // Calculated tip amount

// Final grand total
  var grandTotal = 0.0.obs;

  RxList<Map<String, String>> countryCodes = <Map<String, String>>[].obs;
  RxString selectedCountryCode = '+91'.obs;  // Default to India




  var cartItems = <String, CartItemModel>{}
      .obs; // Key is menuItemID, value is CartItemModel
  String razorpayKey = ""; // Variable to hold the Razorpay key


  void setTipPercentage(int percentage) {
    tipPercentage.value = percentage;
    calculateTipAmount(); // Recalculate tip when percentage is changed
  }

  void calculateTipAmount() {
    if(isTipSelected.value && itemTotalAmount.value >0 ) {
      tipAmount.value = (itemTotalAmount.value * tipPercentage.value) / 100;
    }
    else{
      tipAmount.value = null;
    }
  }


  String? applyPromoCode(String code) {

    if (code.isEmpty) {
      return 'Promo code cannot be empty';
    }

    final promo = promoList.firstWhere(
            (promo) => promo.code.toLowerCase() == code.toLowerCase(),
        orElse: () => PromoCodeModel(code: '', discount: 0));

    if (promo.code.isEmpty) {
      // print("aaaa");
      return 'Invalid promo code';
    } else {

      promoCode.value = promo;
      isPromoApplied.value = true;
      isPromoWidgetVisible.value = false;
      // Get.snackbar('Success', 'Promo code applied successfully!');
      return null;
    }
  }

  void removePromoCode() {
    promoCode.value = null;
    isPromoApplied.value = false;
  }

// Calculate the grand total based on the item total, taxes, tips, and promo code discount
  void calculateGrandTotal() {
    double total = itemTotalAmount.value + taxChargesAmount.value + (tipAmount.value ?? 0);

    // If a promo code is applied, subtract the discount
    if (isPromoApplied.value) {
      total -= promoCode.value!.discount;
    }

    // Ensure the grand total is not less than zero
    grandTotal.value = total < 0 ? 0 : total;
  }


  Future<void> onSuccess(response) async {
    try {
      // print('aaa');
      // String paymentStatus = response['status']; // From Razorpay response
      // String paymentMethod = response['method']; // From Razorpay response
      String transactionID =
          response['razorpay_payment_id']; // From Razorpay response
      //
      // print('aaaa');
      // print(transactionID);
      //
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
        dinerName: dinerName.text, //dinerName.text,
        orderStatusHistory: [
          OrderStatusUpdate(
              status: "Pending",
              updatedTime: DateTime.now(),
              updatedBy: "System")
        ],
        items: orderedItems,
        totalAmount: itemTotalAmount.value, //totalAmount.value,
        paymentMethod: "", // Or other payment methods
        orderDate: todayDate,
        deliveryAddress:
           deliveryAddressController.text, //deliveryAddressController.text, // Replace with dynamic data
        contactNumber:
            contactNumberController.text, //contactNumberController.text, // Replace with dynamic data
        estimatedDeliveryTime: "30 mins", // Dynamically adjust
        paymentStatus: "",
        specialInstructions: instructionController.text,
      );

      // Add the order to Firebase

      await DatabaseMethods().addOrder(orderData.toMap()).then((_) {
        clearCart();
        Get.snackbar("Success", "Order placed successfully!",
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      // Handle any errors that occur during the order process
      // print(e);
      // print("aaaaaaa");
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
    Get.snackbar(
        "Payment Dismissed!", "${response['message']} Please try again.",
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
    itemTotalAmount.value = tempTotal;
    calculateTipAmount();
  }

  // Clear all items from the cart
  void clearCart() {
    cartItems.clear();
    itemTotalAmount.value = 0.0;
  }

  Future<void> initiatePayment() async {
    if (itemTotalAmount > 0) {
      if (razorpayKey.isNotEmpty) {
        // Check if the key is valid
        RazorpayService razorpay = RazorpayService();
        razorpay.openCheckout(
          number: contactNumberController.text,
          amount: isTipSelected.value ? (itemTotalAmount.value * 100 ).toInt() : (double.parse((itemTotalAmount.value + itemTotalAmount.value / 20).toStringAsFixed(2)) * 100).toInt(),
          key: razorpayKey,
          onSuccess: onSuccess,
          onDismiss: onDismiss,
          onFail: onFail,
        );
      } else {
        Get.snackbar(
            "Error", "Razorpay is not available. Please Contact WanderCrew Team.");
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




  Future<void> fetchCountryCodes() async {
    try {
      // print("fetching country codes 1");
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
      if (response.statusCode == 200) {
        // print("fetching country codes 2");

        final List<dynamic> data = jsonDecode(response.body);
        // print("fetching country codes 3");

        countryCodes.value = data.map((country) {
          final root = country['idd']?['root']?.toString() ?? '';
          final suffix = (country['idd']?['suffixes'] is List && country['idd']?['suffixes']?.isNotEmpty == true)
              ? country['idd']['suffixes'][0].toString()
              : '';
          // print("fetching country codes 4");
          return {
            'name': country['name']['common']?.toString() ?? '',
            'code': (root + suffix).isNotEmpty ? root + suffix : '',  // Ensure root+suffix is combined correctly
            'flag': country['flags']?['png']?.toString() ?? '',  // Safely access the flag URL
          };
        }).where((code) => code['code'] != null && code['code']!.isNotEmpty).toList().cast<Map<String, String>>();  // Filter invalid entries and cast correctly
        // print("fetching country codes 5");
        // print(countryCodes.length);
        update();

      } else {
        Get.snackbar("Error", "Failed to fetch country codes");
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch country codes. Please check your internet connection.");
    }
  }

  @override
  void onClose() {
    dinerName.dispose();
    contactNumberController.dispose();
    instructionController.dispose();
    deliveryAddressController.dispose();
    super.onClose();
  }

}
