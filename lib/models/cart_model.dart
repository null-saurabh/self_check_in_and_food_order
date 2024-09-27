import 'menu_item_model.dart';

class CartItemModel {
  MenuItemModel menuItem;
  int quantity;

  CartItemModel({
    required this.menuItem,
    required this.quantity,
  });

  double get totalPrice => menuItem.price * quantity;


  Map<String, dynamic> toMap() {
    return {
      'menuItem': menuItem.toMap(),
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> data) {
    return CartItemModel(
      menuItem: MenuItemModel.fromMap(data['menuItem']),
      quantity: data['quantity'],
    );
  }
}