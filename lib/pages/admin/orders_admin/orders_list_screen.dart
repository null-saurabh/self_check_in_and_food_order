import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/single_order.dart';

import '../../../widgets/widget_support.dart';
import 'admin_order_controller.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminOrderListController>(
      init: AdminOrderListController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Color(0xffFFFEF9),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 46, bottom: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Get.back(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Ordered',
                                style: AppWidget.black24Text600Style()
                                    .copyWith(height: 1),
                              ),
                              Text(
                                'Food',
                                style: AppWidget.black24Text600Style(
                                        color: Color(0xffE7C64E))
                                    .copyWith(height: 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 12),
                        child: TextField(
                          // onChanged: (value) => controller
                          //     .filterMenuItems(value), // Call the search function
                          decoration: InputDecoration(
                            hintText: "Search by item name",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xffEDCC23)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xffEDCC23)),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Obx(() {
                return Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 16),
                        child: Column(
                          children: controller.orderList.map(
                            (orderData) {
                              return SingleOrder(
                                orderData: orderData,
                                initiateRefund: () {
                                  controller.refundAmountController.text = orderData.totalAmount.toString();


                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Edit Price"),
                                        content: TextField(
                                          controller:
                                              controller.refundAmountController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              labelText: "Price"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              controller.initiateRefund(
                                                  paymentId:
                                                      orderData.transactionId,
                                                  refundAmount: double.parse(
                                                      controller
                                                          .refundAmountController
                                                          .text));
                                            },
                                            child: const Text("Refund"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }, //=> controller.initiateRefund(paymentId: orderData.transactionId, refundAmount: orderData.totalAmount,),
                                markAsConfirm: () =>
                                    controller.confirmOrder(orderData, "Admin"),
                                markAsDelivered: () => controller.orderDelivered(
                                    orderData,
                                    "Admin"), //controller.confirmOrder(orderData,"Admin");},
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
