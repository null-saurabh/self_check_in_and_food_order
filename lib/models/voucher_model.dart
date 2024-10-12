import 'package:cloud_firestore/cloud_firestore.dart';

import 'food_order_model.dart';

class CouponUsage {
  dynamic orderModel;         // Can be either FoodOrderModel or BookingOrderModel
  String orderType;           // To specify whether it's a "food" or "booking" order
  DateTime appliedOn;         // Date and time when the coupon was applied
  double appliedDiscountAmount;

  CouponUsage({
    required this.orderModel,
    required this.orderType,
    required this.appliedOn,
    required this.appliedDiscountAmount,
  });

  // Convert to map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'orderModel': orderModel.toMap(),   // Assuming both models have toMap()
      'orderType': orderType,
      'appliedOn': appliedOn,
      'appliedDiscountAmount': appliedDiscountAmount,
    };
  }

  // Factory method to create from Firebase map
  factory CouponUsage.fromMap(Map<String, dynamic> data) {
    return CouponUsage(
      orderModel: data['orderType'] == 'food'
          ? FoodOrderModel.fromMap(data['orderModel'])
          : FoodOrderModel.fromMap(data['orderModel']), //BookingOrderModel.fromMap(data['orderModel']),
      orderType: data['orderType'],
      appliedOn: (data['appliedOn'] as Timestamp).toDate(),
      appliedDiscountAmount: data['appliedDiscountAmount'],
    );
  }
}





class CouponModel {
  String voucherId;                          // Unique coupon ID (e.g., 'COUPON123')
  String title;                       // Coupon title (e.g., "10% OFF Booking")
  String code;                        // The actual coupon code (e.g., 'SAVE20')
  String voucherType;                 // Coupon type: "single-use", "multi-use", "value-based"
  String discountType;                 // Coupon type: "single-use", "multi-use", "value-based"
  double discountValue;               // Discount amount or percentage (e.g., 20.0 for 20%)
  double? remainingDiscountValue;     // Remaining discount value (for value-based coupons)
  DateTime validFrom;                 // Start date of the coupon validity
  DateTime validUntil;                // End date of the coupon validity
  double? minOrderValue;              // Optional: Minimum order value required to apply the coupon
  double? maxDiscount;                // Optional: Maximum discount value (applicable for percentage coupons)
  bool isActive;                      // Status to track if the coupon is active
  bool isUsed;
  int? usageLimit;                    // Number of times the coupon can be used
  int? remainingLimit;                    // Number of times the coupon can be used
  int usageCount;                     // Number of times the coupon has been used
  List<CouponUsage>? usedOnOrders;    // List of CouponUsage records
  List<String> applicableCategories;   // Optional: Categories of food or booking the coupon is applicable for

  CouponModel({
    required this.voucherId,
    required this.title,
    required this.code,
    required this.voucherType,
    required this.discountType,
    required this.discountValue,
    this.remainingDiscountValue,
    required this.validFrom,
    required this.validUntil,
    required this.isUsed,
    this.minOrderValue,
    this.maxDiscount,
    required this.isActive,
    this.usageLimit,
    this.remainingLimit,
    this.usageCount = 0,
    this.usedOnOrders,
    this.applicableCategories = const [],
  });

  // Convert to a map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'voucherId': voucherId,
      'title': title,
      'code': code,
      'voucherType': voucherType,
      'discountType': discountType,
      'discountValue': discountValue,
      'remainingDiscountValue': remainingDiscountValue,
      'validFrom': validFrom,
      'validUntil': validUntil,
      'minOrderValue': minOrderValue,
      'maxDiscount': maxDiscount,
      'isActive': isActive,
      'isUsed': isUsed,
      'usageLimit': usageLimit,
      'remainingLimit': remainingLimit,
      'usageCount': usageCount,
      'usedOnOrders': usedOnOrders?.map((usage) => usage.toMap()).toList(),
      'applicableCategories': applicableCategories,
    };
  }

  // Create CouponModel from Firebase map
  factory CouponModel.fromMap(Map<String, dynamic> data) {
    return CouponModel(
      voucherId: data['voucherId'],
      title: data['title'],
      code: data['code'],
      voucherType: data['voucherType'],
      discountType: data['discountType'],
      discountValue: data['discountValue'],
      remainingDiscountValue: data['remainingDiscountValue'],
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validUntil: (data['validUntil'] as Timestamp).toDate(),
      minOrderValue: data['minOrderValue'],
      maxDiscount: data['maxDiscount'],
      isActive: data['isActive'],
      isUsed: data['isUsed'],
      usageLimit: data['usageLimit'],
      remainingLimit: data['remainingLimit'],
      usageCount: data['usageCount'],
      usedOnOrders: (data['usedOnOrders'] as List<dynamic>?)?.map((item) => CouponUsage.fromMap(item)).toList(),
      applicableCategories: List<String>.from(data['applicableCategories'] ?? []),
    );
  }
}
