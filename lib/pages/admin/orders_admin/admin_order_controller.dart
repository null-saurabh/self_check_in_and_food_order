import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wandercrew/models/food_order_model.dart';

class AdminOrderListController extends GetxController {
  @override
  void onInit() {
    fetchOrderData();
    super.onInit();
  }

  RxList<FoodOrderModel> originalOrderList =
      <FoodOrderModel>[].obs; // Using observable list
  RxList<FoodOrderModel> orderList =
      <FoodOrderModel>[].obs; // Using observable list

  TextEditingController refundAmountController = TextEditingController();

  var isLoading = true.obs; // Loading state
  var selectedFilter = 'None'
      .obs; // To track the selected filter ('None' when no filter is applied)

  TextEditingController filterFromDate = TextEditingController();
  TextEditingController filterToDate = TextEditingController();
  TextEditingController filterMinOrderValue = TextEditingController();
  TextEditingController filterMaxOrderValue = TextEditingController();

  RxInt activeFilterCount = 0.obs;
  ScrollController scrollController = ScrollController();


  Future<void> fetchOrderData() async {

    try {
      isLoading.value = true; // Start loading
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Orders").get();

      List<FoodOrderModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return FoodOrderModel.fromMap(
            data); // Using fromMap factory constructor
      }).toList();

      // Sort orders by orderDate, latest first
      newList.sort(
          (a, b) => b.orderDate.compareTo(a.orderDate)); // Descending order

      orderList.assignAll(newList);
      originalOrderList.assignAll(newList);
      applyDefaultFilter();
      applyRangeFilters();
      update();
    } catch (e) {
      debugPrint('Failed to fetch orders: $e');

    } finally {
      // print("Aaaaa");
      isLoading.value = false; // End loading
    }
  }

  // Method to filter orders by status
  void filterOrdersByStatus({required String label, bool? isFilterButton}) {
    if (selectedFilter.value == label && isFilterButton == null) {
      selectedFilter.value = "None";
      applyDefaultFilter();
      applyRangeFilters();
      update();
      return;
    }
    selectedFilter.value = label;

    if(label == 'None') {
      applyDefaultFilter();

    }
    else if (label == 'All') {
      // Show all orders
      orderList.assignAll(originalOrderList);
    } else if(label == 'Refund'){
      orderList.value = originalOrderList.where((order) {
        return order.isRefunded != null;
      }).toList();
    }
    else {
      var status = label == "Processing" ? "Confirmed" : label == "Completed" ? "Delivered" : label;
      // Filter by specific status (Pending, Completed, Refunded, etc.)
      orderList.value = originalOrderList.where((order) {
        return order.orderStatusHistory.last.status == status;
      }).toList();
    }

    // Ensure orders are sorted by orderDate (latest first)
    orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    applyRangeFilters();
    update();
  }

  // Default filter to show Pending and Processing orders when no filter is selected
  void applyDefaultFilter() {
    if (selectedFilter.value == 'None') {
      orderList.value = originalOrderList.where((order) {
        return order.orderStatusHistory.last.status == 'Pending' ||
            order.orderStatusHistory.last.status == 'Confirmed';
      }).toList();

      // Ensure orders are sorted by orderDate (latest first)
      orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      update();
    }
  }


    void applyRangeFilters() {
      orderList.value = orderList.where((order) {
        bool matchesOrderValue = true;
        bool matchesDateRange = true;
        bool matchesStatus = true;

        // Check if the min order value is provided
        if (filterMinOrderValue.text.isNotEmpty) {
          double minValue = double.tryParse(filterMinOrderValue.text) ?? 0.0;
          matchesOrderValue = order.totalAmount >= minValue;
        }

        // Check if the max order value is provided
        if (filterMaxOrderValue.text.isNotEmpty) {
          double maxValue = double.tryParse(filterMaxOrderValue.text) ?? 1000.0;
          matchesOrderValue = matchesOrderValue && order.totalAmount <= maxValue;
        }

        // Check if the start date is provided
        if (filterFromDate.text.isNotEmpty) {
          DateTime start = DateFormat("dd-MMM-yy").parse(filterFromDate.text);
          matchesDateRange = DateTime.parse(order.orderDate).isAfter(start);
        }

        // Check if the end date is provided
        if (filterToDate.text.isNotEmpty) {
          DateTime end = DateFormat("dd-MMM-yy").parse(filterToDate.text);
          matchesDateRange = matchesDateRange && DateTime.parse(order.orderDate).isBefore(end.add(const Duration(days: 1)));
        }

        return matchesOrderValue && matchesDateRange && matchesStatus;
      }).toList();

      // Sort the filtered orders by date (latest first)
      orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      update();
    }


  void searchFilterOrderItems(String query) {
    if (query.isEmpty) {
      orderList.value =
          List.from(originalOrderList); // Restore the original data
      selectedFilter.value = "All";
    } else {
      selectedFilter.value = "None";
      orderList.value = originalOrderList.where((item) {
        final queryLower = query.toLowerCase();

        return item.dinerName.toLowerCase().contains(queryLower) ||
            item.id.toLowerCase().contains(queryLower) ||
            item.contactNumber.toLowerCase().contains(queryLower);
      }).toList();
    }
    // Ensure orders are sorted by orderDate (latest first)
    orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    update();
  }


  void makePhoneCall(String number) {
    String phoneNumber = number;
    html.window.open('tel:$phoneNumber', '_self');
  }

  Future<void> confirmOrder(BuildContext context,FoodOrderModel item, String adminName) async {
    try {

      showDialog(
        context: context,
        barrierDismissible: false, // Prevents the user from dismissing the dialog
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // print("confirm 4");

      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection("Orders")
      //     .where("orderId",
      //         isEqualTo: item
      //             .orderId) // Assuming 'id' is the custom field name in Firestore
      //     .get();
      //
      // if (querySnapshot.docs.isNotEmpty) {
      //   print("confirm 5");
      //   String docId = querySnapshot.docs.first.id;
      //   print(docId);
      // }

      // print(item.orderId);
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection("Orders")
            .doc(item.id)
            .get();
        // print("confirm 6");

        if (orderSnapshot.exists) {
          // print("confirm 7");

          // Parse the order data into OrderModel
          FoodOrderModel order = FoodOrderModel.fromMap(
              orderSnapshot.data() as Map<String, dynamic>);

          // Add new status update for 'Preparing'
          order.orderStatusHistory.add(
            OrderStatusUpdate(
              status: 'Confirmed',
              updatedTime: DateTime.now(),
              updatedBy: adminName,
            ),
          );
          // print("confirm 8");

          // Update the order status in Firestore
          await FirebaseFirestore.instance
              .collection("Orders")
              .doc(item
              .id)
              .update({
            'orderStatusHistory': order.orderStatusHistory
                .map((status) => status.toMap())
                .toList(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
          // print("confirm 9");
          fetchOrderData();
          context.pop();
          const snackBar = SnackBar(
            content: Text("Success', 'Order status updated to Preparing"),
            backgroundColor: Colors.green,
          );

// Show the snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

        else {
          // print("confirm 8");

          context.pop();

          const snackBar = SnackBar(
            content: Text('Order not found'),
            backgroundColor: Colors.red,
          );

// Show the snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

      // Get the current order data
    } catch (e) {
      context.pop();

      final snackBar = SnackBar(
        content: Text("Error: Failed to update order status: $e"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Function to mark the order as Delivered
  Future<void> orderDelivered(BuildContext context,FoodOrderModel item, String adminName) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents the user from dismissing the dialog
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection("Orders")
      //     .where("orderId",
      //         isEqualTo: item
      //             .orderId) // Assuming 'id' is the custom field name in Firestore
      //     .get();
      //
      // if (querySnapshot.docs.isNotEmpty) {
      //   String  = querySnapshot.docs.first.id;
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection("Orders")
            .doc(item
            .id)
            .get();
        if (orderSnapshot.exists) {
          // Parse the order data into OrderModel

          FoodOrderModel order = FoodOrderModel.fromMap(
              orderSnapshot.data() as Map<String, dynamic>);

          // Add new status update for 'Delivered'
          order.orderStatusHistory.add(
            OrderStatusUpdate(
              status: 'Delivered',
              updatedTime: DateTime.now(),
              updatedBy: adminName,
            ),
          );

          // Update the order status in Firestore
          await FirebaseFirestore.instance
              .collection("Orders")
              .doc(item
              .id)
              .update({
            'orderStatusHistory': order.orderStatusHistory
                .map((status) => status.toMap())
                .toList(),
            'updatedAt': DateTime.now().toIso8601String(),
          });

          fetchOrderData();
          context.pop();
          const snackBar = SnackBar(
            content: Text('Order marked as Delivered'),
            backgroundColor: Colors.green,
          );

// Show the snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        } else {

          const snackBar = SnackBar(
            content: Text('Order not found'),
            backgroundColor: Colors.red,
          );

// Show the snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Failed to update order status: $e'),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }





}
