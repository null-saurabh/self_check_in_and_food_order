import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import '../../../models/cart_model.dart';
import '../../../models/menu_item_model.dart';
import '../../../models/food_order_model.dart';
import '../../../models/voucher_model.dart';
import '../../../service/database.dart';
import '../../../service/razorpay_web.dart';
import 'package:http/http.dart' as http;



class CartScreenController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    fetchRazorpayKey();
    fetchCountryCodes(); // Fetch countries from API when controller is initialized

    // Listen to any changes in relevant fields and recalculate the grand total
    everAll([itemTotalAmount, taxChargesAmount, tipAmount, isCouponApplied], (_) {
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
  Rxn<CouponModel> coupon = Rxn<CouponModel>();
  RxBool isCouponApplied = false.obs;

  RxDouble itemTotalAmount = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble taxChargesAmount = 0.0.obs;
  RxDouble tipAmount = RxDouble(20); // Calculated tip amount
  RxDouble grandTotal = 0.0.obs;

  var tipPercentage = 5.obs; // Percentage of tip selected, default to 0

  RxBool isPromoWidgetVisible = false.obs;


  RxString receptionistText = "Your Cart is Empty".obs;
  RxBool isTipSelected  = true.obs;

  RxnString voucherValidationMessage = RxnString();




  RxList<Map<String, String>> countryCodes = <Map<String, String>>[].obs;
  RxString selectedCountryCode = '+91'.obs;  // Default to India




  var cartItems = <String, CartItemModel>{}
      .obs; // Key is menuItemID, value is CartItemModel
  String razorpayKey = ""; // Variable to hold the Razorpay key
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // void calculateTipAmount() {
  //   if(isTipSelected.value && itemTotalAmount.value >0 ) {
  //     tipAmount.value = (itemTotalAmount.value * tipPercentage.value) / 100;
  //   }
  //   else{
  //     tipAmount.value = null;
  //   }
  // }





  Future<String?> applyCoupon(String code) async {
    if (code.isEmpty) {
      return 'Enter Voucher Code';
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
    // print("1");
    print(code.toUpperCase());
    // Fetch coupon from Firebase where code matches and isUsed is false
    final querySnapshot = await _firestore.collection('Voucher')
        .where('code', isEqualTo: code.toUpperCase())
        .where('isUsed', isEqualTo: false)
        .where('isActive', isEqualTo: true)
        .where('isExpired', isEqualTo: false)
        .limit(1) // Limit to 1 document for efficiency
        .get();

    // print("2");

    if (querySnapshot.docs.isEmpty) {
      // print("3");
      Get.back();
      return 'Invalid coupon code';
    }
    // print("4");

      String docId = querySnapshot.docs.first.id;
      final couponDoc = await _firestore.collection('Voucher').doc(docId).get();
    // print("5");

      if (!couponDoc.exists) {
        // print("6");
        Get.back();
        return 'Invalid coupon code';
      }
    // print("7");

    coupon.value = CouponModel.fromMap(couponDoc.data() as Map<String, dynamic>);
    // print("8");

    final currentCoupon = coupon.value!;
    // print("9");

    // Validate minimum order value
    if (currentCoupon.minOrderValue != null && itemTotalAmount.value < currentCoupon.minOrderValue!) {
      Get.back();
      return 'Minimum order value for this coupon is ₹${currentCoupon.minOrderValue}';
    }
    // print("10");

    // // Validate applicable categories
    // final applicableItems = cartItems.entries.where((entry) {
    //   return currentCoupon.applicableCategories.contains(entry.value.menuItem.category);
    // }).toList();
    //
    // if (applicableItems.isEmpty) {
    //   return 'This coupon is not applicable for the items in your cart';
    // }

    // Validate applicable categories
    if (!currentCoupon.applicableCategories.contains("Food Voucher")) {
      Get.back();
      // If the coupon is a food voucher, it's applicable to all items
      return 'coupon not applicable';
    }
    // print("11");

    // Calculate discount based on discountType (percentage or fixed)
    if (currentCoupon.discountType == 'percentage') {
      // print("11");
      double discount = itemTotalAmount.value * (currentCoupon.discountValue / 100);
      // Apply max discount if applicable
      // print("12");
      // print(discount);

      discountAmount.value = discount > currentCoupon.maxDiscount! ? currentCoupon.maxDiscount! : discount;
      // print("13");
      // print(discountAmount.value);

    } else if (currentCoupon.discountType == 'fixed-discount') {
      discountAmount.value =  itemTotalAmount.value < currentCoupon.discountValue ? itemTotalAmount.value :currentCoupon.discountValue ;
    }
    // print("12");

    // Check for voucherType and update usageCount, remainingDiscountValue, etc.
    if (currentCoupon.voucherType == 'single-use') {
      if (currentCoupon.usageCount >= (currentCoupon.usageLimit ?? 1)) {
        // Mark coupon as used if usage limit is reached
        await _firestore.collection('Voucher').doc(docId).update({
          'isUsed': true,
          'isActive': false,
        });
        Get.back();
        return 'This coupon has been used already';

      }
      // Increment usage count
      // await _firestore.collection('Voucher').doc(docId).update({
      //   'usageCount': FieldValue.increment(1),
      // });
      // await _firestore.collection('Voucher').doc(docId).update({
      //   'isUsed': true,
      // });

    }

    else if (currentCoupon.voucherType == 'multi-use') {

      if (currentCoupon.usageCount >= (currentCoupon.usageLimit ?? 10)) {
        // Mark coupon as used if usage limit is reached
        await _firestore.collection('Voucher').doc(docId).update({
          'isUsed': true,
          'isActive': false,

        });
        Get.back();

        return 'This coupon has reached its usage limit';
      }
      // await _firestore.collection('Voucher').doc(docId).update({
      //   'usageCount': FieldValue.increment(1),
      // });
      //
      // // Check if the coupon is now used
      // if (currentCoupon.usageCount + 1 >= (currentCoupon.usageLimit ?? 10)) {
      //   await _firestore.collection('Voucher').doc(docId).update({
      //     'isUsed': true,
      //   });
      // }

    }
    else if (currentCoupon.voucherType == 'value-based') {

      if (currentCoupon.remainingDiscountValue! <= 0) {
        // print("13");

        await _firestore.collection('Voucher').doc(docId).update({
          'isUsed': true,
          'isActive': false,

        });
        // print("14");
        Get.back();

        return 'This coupon has no remaining value';
      }
      if (currentCoupon.remainingDiscountValue! < discountAmount.value) {
        // print("15");
        discountAmount.value = currentCoupon.remainingDiscountValue!;
      }


      // print("16");
      //
      // if (currentCoupon.remainingDiscountValue! - discountAmount.value <= 0) {
      //   print("17");
      //
      //   // await _firestore.collection('Voucher').doc(docId).update({
      //   //   'remainingDiscountValue': FieldValue.increment(-discountAmount.value),
      //   //   'isUsed': true,
      //   // });
      //   print("18");
      //
      // } else {
      //   print("19");
      //
      //   // await _firestore.collection('Voucher').doc(docId).update({
      //   //   'remainingDiscountValue': FieldValue.increment(-discountAmount.value),
      //   // });
      //   print("20");
      //
      // }
      // print("21");




    }
    // print("22");


    isCouponApplied.value = true;
    isPromoWidgetVisible.value = false;
    Get.back();
    return null;
  }
    catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to apply coupon: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    return "Failed to apply voucher";
  }

  void removePromoCode() {
    coupon.value = null;
    isCouponApplied.value = false;
    discountAmount.value = 0;
  }

// Calculate the grand total based on the item total, taxes, tips, and promo code discount
  void calculateGrandTotal() {
    double total = itemTotalAmount.value + taxChargesAmount.value + (tipAmount.value);

    // If a promo code is applied, subtract the discount
    if (isCouponApplied.value) {
      total -= discountAmount.value;
    }

    // Ensure the grand total is not less than zero
    grandTotal.value = total < 0 ? 0 : total;
  }




  Future<void> onSuccess(response) async {
    try {

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      String transactionID =
          response['razorpay_payment_id']; // From Razorpay response
      String orderId = response['razorpay_order_id'];
      print("printing order: $orderId");
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


      // Create order model
      FoodOrderModel orderData = FoodOrderModel(
        orderId: orderId, // Firebase will generate the ID
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
        createdAt: DateTime.now(),
        couponCode: isCouponApplied.value ? coupon.value!.code: null,
        discount: isCouponApplied.value ? discountAmount.value: null,
      );

      // Add the order to Firebase

      await DatabaseMethods().addOrder(orderData.toMap()).then((_) {
        clearCart();
      });

      // Add logic to update the voucher data if a coupon was applied
      if (isCouponApplied.value) {

        // print(1);
        final querySnapshot = await _firestore.collection('Voucher')
            .where('code', isEqualTo: coupon.value!.code.toUpperCase())
            .where('isUsed', isEqualTo: false)
            .where('isActive', isEqualTo: true)
            .where('isExpired', isEqualTo: false)
            .limit(1) // Limit to 1 document for efficiency
            .get();
        // print(2);


        String docId = querySnapshot.docs.first.id;// Use the id from the coupon model


// Define the CouponUsage data
        CouponUsage couponUsage = CouponUsage(
          orderModel: orderData.toMap(),   // Save the order details
          orderType: "food",               // Assuming this is a food order
          appliedOn: DateTime.now(),       // Time of application
          appliedDiscountAmount: discountAmount.value, // Applied discount
        );

        // print(3);

        // Example of updating voucher usage count and status
        if (coupon.value!.voucherType == 'single-use') {
          // print(4);

          await _firestore.collection('Voucher').doc(docId).update({
            'isUsed': true,
            'isActive': false,
            'usageCount': FieldValue.increment(1),
            'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),
          });
          // print(5);

        }
        else if (coupon.value!.voucherType == 'multi-use') {
          try {
          // print(6);
          print(docId);
          print('Coupon usage data: ${couponUsage.toMap()}');

          await _firestore.collection('Voucher').doc(docId).update({
            'usageCount': FieldValue.increment(1),
            'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),
          });
          // print(7);
        } catch (e) {
      print('Error occurred while updating voucher: $e');
    }

          // Update isUsed if the usage limit is reached
          if (coupon.value!.usageCount + 1 >= (coupon.value!.usageLimit ?? 10)) {
            // print(8);

            await _firestore.collection('Voucher').doc(docId).update({
              'isUsed': true,
              'isActive': false,
            });
            // print(9);

          }
          // print(10);

        }
        else if (coupon.value!.voucherType == 'value-based') {
          // Adjust remaining discount value

          if (coupon.value!.remainingDiscountValue! - discountAmount.value <= 0) {
            // print("17");

            await _firestore.collection('Voucher').doc(docId).update({
              'remainingDiscountValue': FieldValue.increment(
                  -discountAmount.value),
              'isUsed': true,
              'isActive': false,
              'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),

            });
          } else {
              // print("19");

              await _firestore.collection('Voucher').doc(docId).update({
                'remainingDiscountValue': FieldValue.increment(-discountAmount.value),
                'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),

              });
              // print("20");

            }
        }
      }

      Get.back();
      Get.back();

      Get.snackbar("Success", "Order placed successfully!",
          snackPosition: SnackPosition.BOTTOM);
      // Get.toNamed(Routes.receptionMenu);

    } catch (e) {
      // Handle any errors that occur during the order process
      // print(e);
      // print("aaaaaaa");
      Get.back();
      Get.back();
      Get.snackbar(
        "Error",
        "Payment Complete!, But Failed to place the order. Contact Staff.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5)
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
  }

  // Clear all items from the cart
  void clearCart() {
    cartItems.clear();
    itemTotalAmount.value = 0.0;
    grandTotal.value = 0;
    taxChargesAmount.value = 0;
    update();
  }

  Future<void> initiatePayment() async {
    if (itemTotalAmount > 0) {
      if (razorpayKey.isNotEmpty) {
        // Check if the key is valid


        RazorpayService razorpay = RazorpayService();
        razorpay.openCheckout(
          key: razorpayKey,
          number: contactNumberController.text,
          amount: isTipSelected.value ? (itemTotalAmount.value * 100 ).toInt() : (double.parse((itemTotalAmount.value + itemTotalAmount.value / 20).toStringAsFixed(2)) * 100).toInt(),
          onSuccess: onSuccess,
          onDismiss: onDismiss,
          onFail: onFail, name: dinerName.text,
        );
      } else {
        fetchRazorpayKey();
        Get.snackbar(
            "Error", "Razorpay error. Try again! If persists, Please contact WanderCrew Team.");
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
