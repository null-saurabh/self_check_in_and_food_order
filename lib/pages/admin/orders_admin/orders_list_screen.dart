import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/single_order.dart';

import 'admin_order_controller.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminOrderListController>(
      init: AdminOrderListController(),
      builder: (orderController) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2000,
                  child: Obx(() {
                    return Column(
                      children: orderController.getOrderList.map(
                            (orderData) {
                          return SingleOrder(
                            orderName: orderData.orderName,
                            orderAmount: orderData.amount,
                            orderDate: orderData.date,
                          );
                        },
                      ).toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
