import 'package:cloud_firestore/cloud_firestore.dart';

class SelfCheckInModel {
  final String id;        // Required
  final String? documentIssueCountry;
  final String documentType;
  final String frontDocumentUrl;
  final String? backDocumentUrl;
  final String fullName;
  final String? email; // Optional
  final String contact;
  final String age;
  final String? address; // Optional
  final String? city; // Optional
  final String gender;
  final String country;
  final String regionState;
  final String? arrivingFrom; // Optional
  final String? goingTo; // Optional
  final String signatureUrl;
  String? notes;// Additional notes for the item
  final List<String>? tags;      // Tags for search optimization (e.g., spicy, gluten-free)
  dynamic createdAt;  // Change to dynamic to allow FieldValue
  dynamic updatedAt;  // Change to dynamic to allow FieldValue  // Timestamp when the item was last updated
  String? updatedBy;       // The user/admin who last updated the item



  SelfCheckInModel({
    required this.id,
    this.documentIssueCountry,
    required this.documentType,
    required this.frontDocumentUrl,
    this.backDocumentUrl,
    required this.fullName,
    required this.contact,
    required this.age,
    required this.gender,
    required this.country,
    required this.regionState,
    required this.signatureUrl,
    this.email,
    this.address,
    this.city,

    this.arrivingFrom,
    this.goingTo,
    this.notes,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.updatedBy
  });

  // Factory constructor for mapping Firestore data to SelfCheckInModel
  factory SelfCheckInModel.fromMap(Map<String, dynamic> data) {
    return SelfCheckInModel(
      id: data['productId'],
      documentType: data['documentType'],
      documentIssueCountry: data['documentIssueCountry'],
      frontDocumentUrl: data['frontDocumentUrl'],
      backDocumentUrl: data['backDocumentUrl'],
      fullName: data['fullName'],
      email: data['email'], // May be null
      contact: data['contact'],
      age: data['age'],
      address: data['address'], // May be null
      city: data['city'], // May be null
      gender: data['gender'],
      country: data['country'],
      regionState: data['regionState'],
      arrivingFrom: data['arrivingFrom'], // May be null
      goingTo: data['goingTo'], // May be null
      signatureUrl: data['signatureUrl'],
      notes: data['notes'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      updatedBy: data['updatedBy'],
      createdAt:data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null ,  // It can be FieldValue or DateTime
      updatedAt:data['updatedAt'] != null ?  (data['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'productId': id,
      'documentType': documentType,
      'documentIssueCountry': documentIssueCountry,
      'frontDocumentUrl': frontDocumentUrl,
      'backDocumentUrl': backDocumentUrl,
      'fullName': fullName,
      'email' : email,
      'contact': contact,
      'age': age,
      'address': address,
      'city':city,
      'gender': gender,
      'country': country,
      'regionState': regionState,
      'arrivingFrom':arrivingFrom,
      'goingTo':goingTo,
      'signatureUrl': signatureUrl,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      // 'createdAt': Timestamp.fromDate(createdAt),//createdAt ?? FieldValue.serverTimestamp(), // Handle dynamic value
      "updatedAt": updatedAt, // Handle dynamic value
      // "updatedAt": Timestamp.fromDate(updatedAt), // Handle dynamic value
      'notes': notes,
      'tags': tags,

    };


    // Add optional fields only if they're not null or empty
    // if (createdAt != null) data[
    // if (updatedAt != null) data['updatedAt'] = Timestamp.fromDate(updatedAt!);
    if (email != null && email!.isNotEmpty) data['email'] = email;
    if (address != null && address!.isNotEmpty) data['address'] = address;
    if (city != null && city!.isNotEmpty) data['city'] = city;
    if (arrivingFrom != null && arrivingFrom!.isNotEmpty) data['arrivingFrom'] = arrivingFrom;
    if (goingTo != null && goingTo!.isNotEmpty) data['goingTo'] = goingTo;

    return data;
  }
}
