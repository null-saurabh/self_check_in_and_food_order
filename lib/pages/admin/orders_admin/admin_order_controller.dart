import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/food_order_model.dart';

class AdminOrderListController extends GetxController {


  @override
  void onInit() {
    fetchOrderData();
    super.onInit();
  }


  RxList<FoodOrderModel> originalOrderList = <FoodOrderModel>[].obs;  // Using observable list
  RxList<FoodOrderModel> orderList = <FoodOrderModel>[].obs;  // Using observable list

  TextEditingController refundAmountController = TextEditingController();

  var isLoading = true.obs; // Loading state
  var selectedFilter = 'None'.obs;  // To track the selected filter ('None' when no filter is applied)


  Future<void> fetchOrderData() async {
    try {
      isLoading.value = true; // Start loading
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Orders").get();

      List<FoodOrderModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return FoodOrderModel.fromMap(data);  // Using fromMap factory constructor
      }).toList();

      // Sort orders by orderDate, latest first
      newList.sort((a, b) => b.orderDate.compareTo(a.orderDate));  // Descending order


      orderList.assignAll(newList);
      originalOrderList.assignAll(newList);
      applyDefaultFilter();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    }finally {
      // print("Aaaaa");
      isLoading.value = false; // End loading
    }
  }


  // Method to filter orders by status
  void filterOrdersByStatus(String status,String label) {
    if(selectedFilter.value == label) {
      selectedFilter.value = "None";
      applyDefaultFilter();
      update();
      return null;
    }
    selectedFilter.value = label;

    if (status == 'All') {
      // Show all orders
      orderList.assignAll(originalOrderList);
    } else {
      // Filter by specific status (Pending, Completed, Refunded, etc.)
      orderList.value = originalOrderList.where((order) {
        return order.orderStatusHistory.last.status == status;
      }).toList();
    }

    // Ensure orders are sorted by orderDate (latest first)
    orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    update();
  }




  // Default filter to show Pending and Processing orders when no filter is selected
  void applyDefaultFilter() {
    if (selectedFilter.value == 'None') {
      orderList.value = originalOrderList.where((order) {
        return order.orderStatusHistory.last.status == 'Pending' ||
            order.orderStatusHistory.last.status == 'Processing';
      }).toList();

      // Ensure orders are sorted by orderDate (latest first)
      orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      update();
    }
  }


  void SearchFilterOrderItems(String query) {
    if (query.isEmpty) {
      orderList.value = List.from(originalOrderList); // Restore the original data
    } else {
      orderList.value = originalOrderList.where((item) {
        final queryLower = query.toLowerCase();

        return item.dinerName.toLowerCase().contains(queryLower) ||
            item.orderId.toLowerCase().contains(queryLower) ||
            item.contactNumber.toLowerCase().contains(queryLower)
        ;
      }).toList();
    }
    // Ensure orders are sorted by orderDate (latest first)
    orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    update();
  }
  void makePhoneCall(String number) {
    String phoneNumber = '$number';
    html.window.open('tel:$phoneNumber', '_self');
  }

  Future<void> confirmOrder(FoodOrderModel item, String adminName) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      print("confirm 4");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Orders")
          .where("orderId", isEqualTo: item.orderId) // Assuming 'id' is the custom field name in Firestore
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("confirm 5");
        String docId = querySnapshot.docs.first.id;
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection("Orders").doc(docId).get();
        print("confirm 6");

        if (orderSnapshot.exists)  {
          print("confirm 7");

          // Parse the order data into OrderModel
          FoodOrderModel order = FoodOrderModel.fromMap(orderSnapshot.data() as Map<String, dynamic>);

          // Add new status update for 'Preparing'
          order.orderStatusHistory.add(
            OrderStatusUpdate(
              status: 'Confirmed',
              updatedTime: DateTime.now(),
              updatedBy: adminName,
            ),
          );
          print("confirm 8");

          // Update the order status in Firestore
          await FirebaseFirestore.instance.collection("Orders").doc(docId).update({
            'orderStatusHistory': order.orderStatusHistory.map((status) => status.toMap()).toList(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
          print("confirm 9");
          fetchOrderData();
          Get.back();
          Get.snackbar('Success', 'Order status updated to Preparing');
        }
        else {
          Get.snackbar('Error', 'Order not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        }
      }
      else {
        Get.snackbar('Error', 'Order not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,);
      }

      // Get the current order data

    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e');
    }
  }




  // Function to mark the order as Delivered
  Future<void> orderDelivered(FoodOrderModel item, String adminName) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Orders")
          .where("orderId", isEqualTo: item.orderId) // Assuming 'id' is the custom field name in Firestore
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection("Orders").doc(docId).get();
        if (orderSnapshot.exists) {
          // Parse the order data into OrderModel
          FoodOrderModel order = FoodOrderModel.fromMap(orderSnapshot.data() as Map<String, dynamic>);

          // Add new status update for 'Delivered'
          order.orderStatusHistory.add(
            OrderStatusUpdate(
              status: 'Delivered',
              updatedTime: DateTime.now(),
              updatedBy: adminName,
            ),
          );

          // Update the order status in Firestore
          await FirebaseFirestore.instance.collection("Orders").doc(docId).update({
            'orderStatusHistory': order.orderStatusHistory.map((status) => status.toMap()).toList(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
          fetchOrderData();
          Get.back();
          Get.snackbar('Success', 'Order marked as Delivered');
        } else {
          Get.snackbar('Error', 'Order not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        } }else {
          Get.snackbar('Error', 'Order not found');
        }


    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e');
    }
  }

  String razorpayKey = ""; // Variable to hold the Razorpay key


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

  Future<void> initiateRefund({
    required String paymentId,
    required double refundAmount,
  })
  async {

    // This would ideally be a server-side API call, but shown here for simplicity
    try {
      await fetchRazorpayKey();
      if (razorpayKey.isNotEmpty) {

        final url = "https://api.razorpay.com/v1/payments/$paymentId/refund";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$razorpayKey:'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': refundAmount,  // Amount in paise
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Refund initiated: ${response.body}');
        print(response.body);
        // onSuccess(jsonDecode(response.body));
      } else {
        print(response.body);
        Get.snackbar('Error', 'Failed to initiate refund: ${response.body}');
        // onFail(jsonDecode(response.body));
      }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initiate refund: $e');
      // onFail(e);
      print(e);
    }
  }
}
