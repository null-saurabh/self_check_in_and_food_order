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
      QuerySnapshot value = await FirebaseFirestore.instance.collection("Orders").get();
      List<OrderModel> newList = value.docs.map((element) {
        return OrderModel(
          orderName: element.get("orderName"),
          amount: element.get("amount"),
          date: element.get("date"),
        );
      }).toList();

      // Updating observable list
      orderList.assignAll(newList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders');
    }
  }

  // No need for separate getter, you can directly access `orderList`
  List<OrderModel> get getOrderList => orderList;
}
