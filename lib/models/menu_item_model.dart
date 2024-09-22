import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  String id;        // Required
  String name;             // Required
  double price;            // Required
  String category;         // Required
  bool isAvailable;        // Required
  bool isVeg;              // Required

  // Optional Fields
  String? image;
  String? description;     // Brief description of the item
  String? createdBy;       // The user/admin who created the item
  String? updatedBy;       // The user/admin who last updated the item
  dynamic createdAt;  // Change to dynamic to allow FieldValue
  dynamic updatedAt;  // Change to dynamic to allow FieldValue  // Timestamp when the item was last updated
  int? noOfOrders;         // Total number of orders for this item
  String? notes;           // Additional notes for the item
  double? discountPrice;   // Discounted price, if applicable
  List<String>? tags;      // Tags for search optimization (e.g., spicy, gluten-free)
  int? stockCount;         // Number of items in stock
  bool? isFeatured;        // If this item is promoted/featured
  double? ratings;         // Average ratings for the item
  int? ratingsCount;       // Number of ratings given
  List<String>? ingredients; // List of ingredients used
  int? preparationTime;    // Time required to prepare the dish (in minutes)

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
    required this.isVeg,
    this.image,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.noOfOrders,
    this.notes,
    this.discountPrice,
    this.tags,
    this.stockCount,
    this.isFeatured,
    this.ratings,
    this.ratingsCount,
    this.ingredients,
    this.preparationTime,
  });

  // Mapping data from Firebase
  factory MenuItemModel.fromMap(Map<String, dynamic> data) {
    return MenuItemModel(
      id: data['productId'],
      name: data['name'],
      price: data['price'].toDouble(),
      category: data['category'],
      isAvailable: data['isAvailable'],
      isVeg: data['isVeg'],
      image: data['productImage'],
      description: data['description'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      createdAt: data['createdAt'],  // It can be FieldValue or DateTime
      updatedAt: data['updatedAt'],
      // createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      // updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,

      noOfOrders: data['noOfOrders'],
      notes: data['notes'],
      discountPrice: data['discountPrice']?.toDouble(),
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      stockCount: data['stockCount'],
      isFeatured: data['isFeatured'],
      ratings: data['ratings']?.toDouble(),
      ratingsCount: data['ratingsCount'],
      ingredients: data['ingredients'] != null ? List<String>.from(data['ingredients']) : null,
      preparationTime: data['preparationTime'],
    );
  }

  // Convert to map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'name': name,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
      'isVeg': isVeg,
      'productImage': image,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(), // Handle dynamic value
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(), // Handle dynamic value
      // 'createdAt': createdAt,
      // 'updatedAt': updatedAt,
      'noOfOrders': noOfOrders,
      'notes': notes,
      'discountPrice': discountPrice,
      'tags': tags,
      'stockCount': stockCount,
      'isFeatured': isFeatured,
      'ratings': ratings,
      'ratingsCount': ratingsCount,
      'ingredients': ingredients,
      'preparationTime': preparationTime,
    };
  }
}


