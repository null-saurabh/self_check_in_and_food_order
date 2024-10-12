import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/single_order.dart';
import '../../../widgets/filter_button.dart';
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
                        padding: const EdgeInsets.only(top: 20, bottom: 12),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                              child: TextField(
                                onChanged: (value) =>
                                    controller.SearchFilterOrderItems(
                                        value), // Call the search function
                                decoration: InputDecoration(
                                  hintText: "Search by name, number, orderId",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Color(0xffEDCC23)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Color(0xffEDCC23)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Color(0xffEDCC23)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                FilterButton(
                                  label: "All",
                                  isSelected:
                                      controller.selectedFilter.value == "All",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        "All", "All");
                                  },
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                FilterButton(
                                  label: "Pending",
                                  isSelected: controller.selectedFilter.value ==
                                      "Pending",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        "Pending", "Pending");
                                  },
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                FilterButton(
                                  label: "Processing",
                                  isSelected: controller.selectedFilter.value ==
                                      "Processing",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        "Confirmed", "Processing");
                                  },
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                FilterButton(
                                  label: "Completed",
                                  isSelected: controller.selectedFilter.value ==
                                      'Completed',
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        "Delivered", "Completed");
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.orderList.isNotEmpty) {
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
                                  onCallPressed: () {
                                    controller
                                        .makePhoneCall(orderData.contactNumber);
                                  },
                                  orderData: orderData,
                                  initiateRefund: () {
                                    controller.refundAmountController.text =
                                        orderData.totalAmount.toString();

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Edit Price"),
                                          content: TextField(
                                            controller: controller
                                                .refundAmountController,
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
                                  markAsConfirm: () => controller.confirmOrder(
                                      orderData, "Admin"),
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
                } else if (controller.isLoading.value) {
                  return Expanded(
                      child: const Center(child: CircularProgressIndicator()));
                } else {
                  switch (controller.selectedFilter.value) {
                    case 'Completed':
                      return Expanded(child: Center(child: Text('No completed orders found.')));
                    case 'Pending':
                      return Expanded(child: Center(child: Text('No pending orders found.')));
                    case 'Processing':
                      return Expanded(child: Center(child: Text('No processing orders found.')));
                    case 'Refunded':
                      return Expanded(child: Center(child: Text('No refunded orders found.')));
                    case 'All':
                      return Expanded(child: Center(child: Text('No orders found.')));
                    default:
                      // If no filter is selected (default), show a message for pending and processing orders
                      return Expanded(
                        child: Center(
                            child:
                                Text('No pending found.')),
                      );
                  }
                }
              }),
            ],
          ),
        );
      },
    );
  }
}
