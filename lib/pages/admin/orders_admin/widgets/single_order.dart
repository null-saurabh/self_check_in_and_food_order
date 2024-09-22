import 'package:flutter/material.dart';


class SingleOrder extends StatelessWidget {
  final String orderName;
  final double orderAmount;
  final String orderDate;
  const SingleOrder({super.key,required this.orderName, required this.orderAmount, required this.orderDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(orderName),
        subtitle: Text(orderDate),
        trailing: Text(orderAmount.toString()),
      ),
    );
  }
}
