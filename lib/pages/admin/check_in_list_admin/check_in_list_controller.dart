import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/self_checking_model.dart';

class CheckInListController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    fetchCheckInList();  // Fetch data when controller is initialized
  }

  RxList<SelfCheckInModel> checkInList = <SelfCheckInModel>[].obs;  // Using observable list


  Future<void> fetchCheckInList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Self_Check_In").get();
      print("aa");
      // Mapping Fire store data to model and updating observable list
      List<SelfCheckInModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return SelfCheckInModel.fromMap(data);  // Using fromMap factory constructor
      }).toList();
      print("aaa");


      // Updating observable list
      checkInList.assignAll(newList);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders');
    }
  }

}