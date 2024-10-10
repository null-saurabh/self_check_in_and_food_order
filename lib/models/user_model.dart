import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  String id;
  String name;               // Name of the staff member
  String userId;             // Unique user ID or username
  String password;           // Password for login
  String role;               // Role in the system (e.g., Admin, Staff)
  String permission;         // Permissions associated with the user
  bool isOnline;             // Status to track if the user is currently online
  String number;             // Contact number of the user
  String address;            // Address of the user
  String documentType;       // Type of document (e.g., ID, Passport)
  String frontDocumentUrl;  // Front side of the document
  String? backDocumentUrl;  // Nullable back side of the document
  List<DateTime> loginData; // List of timestamps representing login history

  AdminUserModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.password,
    required this.role,
    required this.isOnline,
    required this.permission,
    required this.number,
    required this.address,
    required this.documentType,
    required this.frontDocumentUrl,
    this.backDocumentUrl,
    required this.loginData,
  });

  // Convert the AdminUserModel to a map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'userId': userId,
      'password': password,
      'role': role,
      'permission': permission,
      'isOnline': isOnline,
      'number': number,
      'address': address,
      'documentType': documentType,
      'frontDocumentType': frontDocumentUrl,
      'backDocumentType': backDocumentUrl,
      'loginData': loginData.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }

  // Factory constructor to create an AdminUserModel from a Firebase map
  factory AdminUserModel.fromMap(Map<String, dynamic> data) {
    return AdminUserModel(
      id: data['id'],
      name: data['name'],
      userId: data['userId'],
      password: data['password'],
      role: data['role'],
      permission: data['permission'],
      isOnline: data['isOnline'],
      number: data['number'],
      address: data['address'],
      documentType: data['documentType'],
      frontDocumentUrl: data['frontDocumentType'],
      backDocumentUrl: data['backDocumentType'],
      loginData: List<DateTime>.from(
          (data['loginData'] as List<dynamic>).map((timestamp) => (timestamp as Timestamp).toDate()))
          ,
    );
  }
}
