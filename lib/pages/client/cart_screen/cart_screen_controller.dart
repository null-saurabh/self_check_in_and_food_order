import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../models/cart_model.dart';
import '../../../models/menu_item_model.dart';
import '../../../models/food_order_model.dart';
import '../../../models/voucher_model.dart';
import '../../../service/razorpay_web.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../../../utils/routes.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/confirmDialog.dart';
import '../../../widgets/widget_support.dart';



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


  Future<String?> applyCoupon(BuildContext context,String code) async {
    if (code.isEmpty) {
      return 'Enter Voucher Code';
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
    // print("1");
    // print(code.toUpperCase());
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
      context.pop();
      return 'Invalid coupon code';
    }
    // print("4");

      String docId = querySnapshot.docs.first.id;
      final couponDoc = await _firestore.collection('Voucher').doc(docId).get();
    // print("5");

      if (!couponDoc.exists) {
        // print("6");
        context.pop();
        return 'Invalid coupon code';
      }
    // print("7");

    coupon.value = CouponModel.fromMap(couponDoc.data() as Map<String, dynamic>);
    // print("8");

    final currentCoupon = coupon.value!;
    // print("9");

    // Validate minimum order value
    if (currentCoupon.minOrderValue != null && itemTotalAmount.value < currentCoupon.minOrderValue!) {
      context.pop();
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
      context.pop();
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
        context.pop();
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
        context.pop();

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
        context.pop();

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
    context.pop();
    return null;
  }
    catch (e) {
      context.pop();
      final snackBar = SnackBar(
        content: Text("Error: Failed to apply coupon: $e"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


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


  Future<void> onSuccess(BuildContext context) async {

    try {



      showDialog(
        context: context,
        barrierDismissible: false, // Prevents the user from dismissing the dialog
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // String transactionID =
      //     response['razorpay_payment_id']; // From Razorpay response
      // String orderId = response['razorpay_order_id'];
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
        id: "",
        // orderId: orderId, // Firebase will generate the ID
        // transactionId: transactionID,
        dinerName: dinerName.text, //dinerName.text,
        orderStatusHistory: [
          OrderStatusUpdate(
              status: "Pending",
              updatedTime: DateTime.now(),
              updatedBy: "System")
        ],
        items: orderedItems,
        totalAmount: grandTotal.value, //totalAmount.value,
        paymentMethod: "", // Or other payment methods
        orderDate: todayDate,
        deliveryAddress:
           deliveryAddressController.text == "" ? 'N/A' :  deliveryAddressController.text, //deliveryAddressController.text, // Replace with dynamic data
        contactNumber:
            contactNumberController.text, //contactNumberController.text, // Replace with dynamic data
        estimatedDeliveryTime: "30 mins", // Dynamically adjust
        paymentStatus: "",
        specialInstructions: instructionController.text == "" ? 'N/A' : instructionController.text,
        createdAt: DateTime.now(),
        couponCode: isCouponApplied.value ? coupon.value!.code: null,
        discount: isCouponApplied.value ? discountAmount.value: null,
      );

      // Add the order to Firebase
      DocumentReference docRef = await FirebaseFirestore.instance
            .collection("Orders")
            .add(orderData.toMap());

      String id = docRef.id; // Retrieve the autogenerated ID
      await docRef.update({'id': id});
        clearCart();

      // Updating Voucher (if applied)
      if (isCouponApplied.value) {
        await _updateVoucherUsage(orderData);
      }


      // Update the number of orders for each menu item
      for (var orderedItem in orderedItems) {
        DocumentReference menuItemDocRef = FirebaseFirestore.instance
            .collection('Menu')
            .doc(orderedItem.menuItemId);

        try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(menuItemDocRef);

          if (!snapshot.exists) {
            throw Exception("Menu item does not exist!");
          }

          // Get current values for `noOfOrders` and `stockCount`
          int currentOrderCount = snapshot['noOfOrders'] ?? 0;
          int currentStockCount = snapshot['stockCount'] ?? 0; // Default to 0 if stockCount doesn't exist

          // Calculate the new order count after this transaction
          int updatedOrderCount = currentOrderCount + orderedItem.quantity;
          int updatedStockCount = currentStockCount - orderedItem.quantity;

          transaction.update(menuItemDocRef, {
            'noOfOrders': updatedOrderCount,
            'stockCount': updatedStockCount,
            'isAvailable': updatedStockCount > 0, // Set false if orders reach/exceed stock
          });
          //
          // transaction.update(menuItemDocRef, {
          //   'noOfOrders': currentOrderCount + orderedItem.quantity,
          // });
        });
      } catch (e) {
      print('Error updating menu item: $e');
      throw Exception('Failed to update menu item');
    }
      }

      context.pop();
      // navigateToMenu(context);

      // const snackBar = SnackBar(
      //   content: Text("Success Order placed successfully!."),
      //   backgroundColor: Colors.green,
      // );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12.0), // Customize the radius here
            ),
            backgroundColor: const Color(0xffFFFEF9),
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.68),
              child: Padding(
                padding:
                const EdgeInsets.only(top: 20, right: 20.0, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Order Placed!",
                      style: AppWidget.green18Text600Style(),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppElevatedButton(
                            title: "Track",
                            height: 40,
                            titleTextSize: 14,
                            borderColor: Colors.transparent,
                            titleTextColor: Colors.white,
                            backgroundColor: Color(0xff2196F3),
                            onPressed: () {
                              context.pop();
                              navigateToTrackOrder(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: AppElevatedButton(
                            title: "Ok",
                            height: 40,
                            titleTextSize: 14,
                            titleTextColor: Color(0xff212121),
                            backgroundColor: Color(0xffE0E0E0),
                            onPressed: () {
                              context.pop();
                              navigateToMenu(context);
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );








    } catch (e) {

      context.pop();
      // context.pop();
      print(e);

      final snackBar = SnackBar(
        content: Text("Error: Payment Complete!, But Failed to place the order. Contact Staff.$e"),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);



    }
  }

  // Separate function to handle voucher updates (optional)

  Future<void> _updateVoucherUsage(FoodOrderModel orderData) async {
    try {
      final querySnapshot = await _firestore.collection('Voucher')
          .where('code', isEqualTo: coupon.value!.code.toUpperCase())
          .where('isUsed', isEqualTo: false)
          .where('isActive', isEqualTo: true)
          .where('isExpired', isEqualTo: false)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Voucher not found or no longer valid');
      }

      String docId = querySnapshot.docs.first.id;

      CouponUsage couponUsage = CouponUsage(
        orderModel: orderData.toMap(),
        orderType: "food",
        appliedOn: DateTime.now(),
        appliedDiscountAmount: discountAmount.value,
      );

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(_firestore.collection('Voucher').doc(docId));

        if (!snapshot.exists) {
          throw Exception("Voucher does not exist!");
        }

        int currentUsageCount = snapshot['usageCount'] ?? 0;
        double remainingDiscountValue = snapshot['remainingDiscountValue'] ?? 0;

        // Single-use voucher logic
        if (coupon.value!.voucherType == 'single-use') {
          transaction.update(_firestore.collection('Voucher').doc(docId), {
            'isUsed': true,
            'isActive': false,
            'usageCount': FieldValue.increment(1),
            'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),
          });
        }

        // Multi-use voucher logic
        else if (coupon.value!.voucherType == 'multi-use') {
          transaction.update(_firestore.collection('Voucher').doc(docId), {
            'usageCount': FieldValue.increment(1),
            'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),
          });

          // Deactivate if the usage limit is reached
          if (currentUsageCount + 1 >= (coupon.value!.usageLimit ?? 10)) {
            transaction.update(_firestore.collection('Voucher').doc(docId), {
              'isUsed': true,
              'isActive': false,
            });
          }
        }

        // Value-based voucher logic
        else if (coupon.value!.voucherType == 'value-based') {
          if (remainingDiscountValue - discountAmount.value <= 0) {
            transaction.update(_firestore.collection('Voucher').doc(docId), {
              'remainingDiscountValue': FieldValue.increment(-discountAmount.value),
              'isUsed': true,
              'isActive': false,
              'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),
            });
          } else {
            transaction.update(_firestore.collection('Voucher').doc(docId), {
              'remainingDiscountValue': FieldValue.increment(-discountAmount.value),
              'usedOnOrders': FieldValue.arrayUnion([couponUsage.toMap()]),
            });
          }
        }
      });
    } catch (e) {
      print('Error updating voucher usage: $e');
      throw Exception('Failed to update voucher usage');
    }
  }


  void navigateToMenu(BuildContext context) {

    // Replace the current route with the new route
    html.window.history.replaceState({}, '', '/reception');
    // html.window.history.replaceState({}, '', Routes.receptionHome);
    context.go(Routes.receptionMenu);
  }


  void navigateToTrackOrder(BuildContext context) {

    // Replace the current route with the new route
    html.window.history.replaceState({}, '', '/reception');
    // html.window.history.replaceState({}, '', Routes.receptionHome);
    context.go(Routes.receptionTrackOrder);
  }




  // Handle payment failure
  void onFail(BuildContext context,response) {
    final snackBar = SnackBar(
      content: Text("Payment Failed: ${response['message']} Please try again."),
      backgroundColor: Colors.red,
    );

// Show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  void onDismiss(response) {
    debugPrint("Failed/Dismissed Payment");
  }

  // Add item to cart or update quantity
  void addItem(MenuItemModel menuItem, int quantity, BuildContext context) {

    if (menuItem.stockCount != null) {
      if (cartItems.containsKey(menuItem.id)) {
        final currentQuantity = cartItems[menuItem.id]!.quantity;
        if (currentQuantity + quantity > menuItem.stockCount!) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot add more than available stock (${menuItem
                  .stockCount}).'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        cartItems[menuItem.id]!.quantity += quantity;
      } else {
        if (quantity > menuItem.stockCount!) {
          // Show Snackbar if initial quantity exceeds stock
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Cannot add more than available stock (${menuItem.stockCount}).'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        cartItems[menuItem.id] =
            CartItemModel(menuItem: menuItem, quantity: quantity);
      }
    } else {
      // If stock is not defined, proceed with adding the item
      if (cartItems.containsKey(menuItem.id)) {
        cartItems[menuItem.id]!.quantity += quantity;
      } else {
        cartItems[menuItem.id] =
            CartItemModel(menuItem: menuItem, quantity: quantity);
      }
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

  Future<void> initiatePayment(BuildContext context) async {
    if (itemTotalAmount > 0) {
      if (razorpayKey.isNotEmpty) {
        // Check if the key is valid


        RazorpayService razorpay = RazorpayService();
        razorpay.openCheckout(
          buildContext: context,
          key: razorpayKey,
          number: contactNumberController.text,
          amount:grandTotal.value.toInt() * 100,
          onSuccess: onSuccess,
          onDismiss: onDismiss,
          onFail: onFail, name: dinerName.text,
        );
      } else {
        fetchRazorpayKey();
        const snackBar = SnackBar(
          content: Text("Error: Razorpay error. Try again! If persists, Please contact WanderCrew Team."),
          backgroundColor: Colors.red,
        );

// Show the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);


      }
    } else {
      const snackBar = SnackBar(
        content: Text("Error: Total amount must be greater than zero."),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

        debugPrint("Razorpay key not found");

      }
    } catch (e) {
      debugPrint("Failed to fetch Razorpay key: $e");


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
        debugPrint("Error: Failed to fetch country codes");
      }
    } catch (e) {
      debugPrint("Error: Unable to fetch country codes. Please check your internet connection.");

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
