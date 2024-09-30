import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/self_checking_model.dart';

class CheckInListController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    fetchCheckInList();  // Fetch data when controller is initialized
  }

  RxList<SelfCheckInModel> checkInList = <SelfCheckInModel>[].obs;  // Using observable list
  RxMap<String, List<SelfCheckInModel>> groupedCheckIns = <String, List<SelfCheckInModel>>{}.obs;


  Future<void> fetchCheckInList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Self_Check_In").get();

      // Mapping Fire store data to model and updating observable list
      List<SelfCheckInModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return SelfCheckInModel.fromMap(data);  // Using fromMap factory constructor
      }).toList();
      // print(newList);


      // Updating observable list
      checkInList.assignAll(newList);
      groupCheckInsByDate();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch list $e');
      // print(e);
    }
  }


  void groupCheckInsByDate() {
    Map<String, List<SelfCheckInModel>> groupedData = {};
    for (var checkIn in checkInList) {
      // Formatting DateTime to a string date
      String formattedDate = DateFormat('dd/MM/yyyy').format(checkIn.createdAt!
       );
      if (!groupedData.containsKey(formattedDate)) {
        groupedData[formattedDate] = [];
      }
      groupedData[formattedDate]!.add(checkIn);
    }
    groupedCheckIns.assignAll(groupedData);
    update();
  }

}