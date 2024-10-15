import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../models/voucher_model.dart';
import '../manage_voucher_controller.dart';

class AddVoucherAdminController extends GetxController {
  var isEditing = false.obs;
  var editingItem = Rxn<CouponModel>();

  // Modify the constructor to accept an item
  AddVoucherAdminController({CouponModel? data}) {
    if (data != null) {
      isEditing.value = true;
      setEditingItem(data);
    }
  }

  @override
  void onInit() {
    super.onInit();
    voucherCodeController.addListener(() {
      final text =
          voucherCodeController.text.toUpperCase(); // Convert to uppercase
      voucherCodeController.value = voucherCodeController.value.copyWith(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
        composing: TextRange.empty,
      );
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var voucherCodeController = TextEditingController();
  var discountValueController = TextEditingController();
  var titleController = TextEditingController();
  var minOrderValueController = TextEditingController();
  var maxLimitController = TextEditingController();
  var maxDiscountController = TextEditingController();
  var remainingDiscountValueController = TextEditingController();
  var remainingLimitController = TextEditingController();

  RxBool isActive = true.obs;
  RxInt usageCount = 0.obs;
  RxList<CouponUsage> usedOnOrders = RxList<CouponUsage>();

  TextEditingController validFromController = TextEditingController(
    text: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
  );

  var expirationDateController = TextEditingController(
    text:
        DateFormat('dd-MMM-yyyy').format(DateTime.now().add(Duration(days: 1))),
  );

  RxString selectedVoucherType = RxString("single-use");
  RxString selectedDiscountType = RxString("fixed-discount");

  RxnString selectedCategories = RxnString();
  var createdAt;

  void setEditingItem(CouponModel item) {
    editingItem.value = item;
    // Populate fields with item data
    voucherCodeController.text = item.code.toUpperCase();
    discountValueController.text = item.discountValue.toString();
    titleController.text = item.title;
    minOrderValueController.text = item.minOrderValue.toString();
    if (item.voucherType == "multi-use")
      maxLimitController.text = item.usageLimit.toString();
    selectedVoucherType.value = item.voucherType;
    selectedDiscountType.value = item.discountType;
    selectedCategories.value = item.applicableCategories.last;
    if (item.discountType == "percentage")
      maxDiscountController.text = item.maxDiscount.toString();
    validFromController.text = DateFormat('dd-MMM-yyyy').format(item.validFrom);
    expirationDateController.text =
        DateFormat('dd-MMM-yyyy').format(item.validUntil);
    if (item.voucherType == "value-based")
      remainingDiscountValueController.text =
          item.remainingDiscountValue.toString();
    if (item.voucherType != "value-based")
      remainingLimitController.text = item.remainingLimit.toString();
    createdAt = item.createdAt ?? DateTime.now();

    update();
  }

  String generateVoucherCode(int length) {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> submitCouponData(BuildContext context) async {

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Generate a unique coupon ID

      // If editing an existing coupon
      // if (isEditing.value) {
      //   couponId = editingItem.value!.voucherId; // Use the existing coupon ID
      // }

      // Prepare coupon data
      CouponModel newCoupon = CouponModel(
          voucherId: isEditing.value ?editingItem.value!.voucherId : "",
          title: titleController.text.trim(),
          code: voucherCodeController.text.trim(),
          voucherType: selectedVoucherType.value,
          discountType: selectedDiscountType.value,
          discountValue: double.parse(discountValueController.text.trim()),
          remainingDiscountValue: selectedVoucherType.value == "value-based"
              ? isEditing.value
                  ? double.tryParse(
                      remainingDiscountValueController.text.trim())
                  : double.tryParse(discountValueController.text.trim())
              : null,
          validFrom: DateFormat("dd-MMM-yy").parse(
              validFromController.text), // Use the date from the controller
          validUntil: DateFormat("dd-MMM-yy").parse(expirationDateController
              .text), // Use the date from the controller
          minOrderValue: minOrderValueController.text.isNotEmpty
              ? double.tryParse(minOrderValueController.text.trim())
              : null,
          maxDiscount: maxDiscountController.text.isNotEmpty
              ? double.tryParse(maxDiscountController.text.trim())
              : null,
          isActive: isActive.value,
          usageLimit: selectedVoucherType.value == "single-use"
              ? 1
              : maxLimitController.text.isNotEmpty
                  ? int.tryParse(maxLimitController.text.trim())
                  : null,
          remainingLimit: isEditing.value
              ? int.tryParse(remainingLimitController.text.trim())
              : selectedVoucherType.value == "single-use"
                  ? 1
                  : selectedVoucherType.value == "multi-use"
                      ? int.tryParse(maxLimitController.text.trim())
                      : null,
          usageCount: usageCount.value, // Initialize with 0 for new coupons
          usedOnOrders: usedOnOrders,
          applicableCategories: [selectedCategories.value ?? "Food Voucher"],
          isUsed: false,
          createdAt: isEditing.value ? createdAt.value : DateTime.now(),
          updatedAt: isEditing.value ? DateTime.now() : null,
          updatedBy: isEditing.value ? "Admin" : null,
          isExpired: isEditing.value
              ? DateTime.now().isAfter(DateFormat("dd-MMM-yy")
                      .parse(expirationDateController.text)
                      .add(Duration(days: 1)))
                  ? true
                  : DateTime.now().isBefore(DateFormat("dd-MMM-yy")
                          .parse(validFromController.text))
                      ? true
                      : false
              : false);

      if (isEditing.value) {
        // Updating an existing coupon
        try {
        //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        //       .collection("Voucher")
        //       .where("voucherId",
        //           isEqualTo: couponId) // Matching the existing coupon ID
        //       .get();
        //
        //   if (querySnapshot.docs.isNotEmpty) {
        //     String  = querySnapshot.docs.first.id;

            // Update the coupon document in Firebase
            await FirebaseFirestore.instance
                .collection("Voucher")
                .doc(editingItem.value!.voucherId)
                .update(newCoupon.toMap());

            // Update locally
            ManageVoucherAdminController couponController =
                Get.find<ManageVoucherAdminController>();
            int index = couponController.voucherList
                .indexWhere((coupon) => coupon.voucherId == editingItem.value!.voucherId);
            if (index != -1) {
              couponController.voucherList[index] = newCoupon;
              couponController.update();
            }

            // Update locally
            int index2 = couponController.originalVoucherList
                .indexWhere((coupon) => coupon.voucherId == editingItem.value!.voucherId);
            if (index2 != -1) {
              couponController.originalVoucherList[index2] = newCoupon;
              couponController.update();
            }

            context.pop(); // Close loading dialog
            context.pop(); // Return to previous page

            // Show success message
            Get.snackbar(
              "Success",
              "Coupon updated successfully.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          // } else {
          //   ""();
          //   Get.snackbar(
          //     "Error",
          //     "Coupon not found.",
          //     snackPosition: SnackPosition.BOTTOM,
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white,
          //   );
          // }
        } catch (error) {
          context.pop();
          Get.snackbar(
            "Error",
            "Failed to update coupon: $error",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Saving a new coupon
        DocumentReference docRef =  await FirebaseFirestore.instance
            .collection("Voucher")
            .add(newCoupon.toMap());

        String id = docRef.id; // Retrieve the autogenerated ID

        // Optionally, update the document with the newly assigned ID
        await docRef.update({'id': id});

        // Update locally
        ManageVoucherAdminController couponController =
            Get.find<ManageVoucherAdminController>();

        couponController.voucherList.add(newCoupon);
        couponController.update();
        context.pop(); // Close loading dialog
        context.pop(); // Return to previous page

        Get.snackbar(
          "Success",
          "Coupon added successfully!",
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );

        clearFields(); // Reset fields after adding a new coupon
      }
    } catch (e) {
      context.pop();
      Get.snackbar(
        "Error",
        "Failed to save coupon: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void clearFields() {
    // Clear text fields
    titleController.clear();
    voucherCodeController.clear();
    discountValueController.clear();
    minOrderValueController.clear();
    maxDiscountController.clear();
    maxLimitController.clear();

    // Reset date pickers
    validFromController.text = DateFormat('dd-MMM-yyyy')
        .format(DateTime.now()); // Set 'Valid From' to tomorrow by default
    expirationDateController.text = DateFormat('dd-MMM-yyyy').format(
        DateTime.now().add(Duration(
            days: 1))); // Set 'Expiration Date' to a week later by default

    // Reset dropdowns and selections
    selectedVoucherType.value = ""; // Reset voucher type selection
    selectedDiscountType.value = ""; // Reset discount type selection
    selectedCategories.value = null; // Clear selected categories

    // Reset editing flag
    isEditing.value = false;

    // Reset the editing item (if any)
    editingItem.value = null;

    // Update the UI to reflect changes
    update();
  }
}
