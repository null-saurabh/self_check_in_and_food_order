// import 'package:flutter/material.dart';
//
// class CartProvider with ChangeNotifier {
//   Map<String, int> _cartItems = {}; // Store product ID and quantity
//
//   // Add item to cart or update quantity if already exists
//   void addItem(String productId, int quantity) {
//     if (_cartItems.containsKey(productId)) {
//       _cartItems[productId] = _cartItems[productId]! + quantity;
//     } else {
//       _cartItems[productId] = quantity;
//     }
//     notifyListeners();
//   }
//
//   // Remove item from cart
//   void removeItem(String productId) {
//     _cartItems.remove(productId);
//     notifyListeners();
//   }
//
//   // Decrease item quantity or remove if 0
//   void decreaseItem(String productId) {
//     if (_cartItems.containsKey(productId)) {
//       if (_cartItems[productId]! > 1) {
//         _cartItems[productId] = _cartItems[productId]! - 1;
//       } else {
//         _cartItems.remove(productId);
//       }
//       notifyListeners();
//     }
//
//
//   }
//   void clearCart(){
//     _cartItems.clear();
//     notifyListeners();
//
//   }
//
//
//   // Get all cart items
//   Map<String, int> get cartItems => _cartItems;
//
//   // Get item count
//   int getItemCount(String productId) {
//     return _cartItems[productId] ?? 0;
//   }
//
//   // Get total items in the cart
//   int get totalItems => _cartItems.length;
// }
