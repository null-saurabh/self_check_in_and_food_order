import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/order_model.dart';

class AdminOrderListController extends GetxController {


  @override
  void onInit() {
    fetchOrderData();
    super.onInit();
  }


  RxList<OrderModel> orderList = <OrderModel>[].obs;  // Using observable list

  // Fetch data from Firestore and update orderList

  Future<void> fetchOrderData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Orders").get();

      // Mapping Firestore data to OrderModel and updating observable list
      List<OrderModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return OrderModel.fromMap(data);  // Using fromMap factory constructor
      }).toList();

      // Updating observable list
      orderList.assignAll(newList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    }
  }


  // No need for separate getter, you can directly access `orderList`
  List<OrderModel> get getOrderList => orderList;
}
