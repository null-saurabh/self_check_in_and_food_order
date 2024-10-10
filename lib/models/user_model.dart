import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  String name;               // Name of the staff member
  String userId;             // Unique user ID or username
  String password;           // Password for login
  String role;               // Role in the system (e.g., Admin, Staff)
  bool isOnline;             // Status to track if the user is currently online
  List<DateTime>? loginData;  // List of timestamps representing login history

  AdminUserModel({
    required this.name,
    required this.userId,
    required this.password,
    required this.role,
    required this.isOnline,
    this.loginData,
  });

  // Convert the AdminUserModel to a map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'password': password,
      'role': role,
      'isOnline': isOnline,
      'loginData': loginData?.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }

  // Factory constructor to create an AdminUserModel from a Firebase map
  factory AdminUserModel.fromMap(Map<String, dynamic> data) {
    return AdminUserModel(
      name: data['name'],
      userId: data['userId'],
      password: data['password'],
      role: data['role'],
      isOnline: data['isOnline'],
      loginData: data['loginData'] != null
          ? List<DateTime>.from(
          (data['loginData'] as List<dynamic>).map((timestamp) => (timestamp as Timestamp).toDate()))
          : null,);
  }
}
