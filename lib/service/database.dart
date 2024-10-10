import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future addFoodItem(Map<String, dynamic> foodItemData) async {
    return await FirebaseFirestore.instance
        .collection("Menu")
        .add(foodItemData);
  }

  Future updateFoodItem(String itemId,Map<String, dynamic> foodItemData) async {
    return await FirebaseFirestore.instance
        .collection("Menu")
        .doc(itemId)
        .update(foodItemData);
  }

  Future updateUserData(String itemId,Map<String, dynamic> foodItemData) async {
    return await FirebaseFirestore.instance
        .collection("AdminAccount")
        .doc(itemId)
        .update(foodItemData);
  }

  Future addOrder(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .add(userInfoMap);
  }

  Future<void> addSelfCheckInData(Map<String, dynamic> checkInData) async {
    await FirebaseFirestore.instance
        .collection('Self_Check_In')
        .add(checkInData);
  }

  Future<void> addNewUser(Map<String, dynamic> newUserData) async {
    await FirebaseFirestore.instance
        .collection('AdminAccount')
        .add(newUserData);
  }

}
