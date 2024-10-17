import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/order_filter_alert.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/single_order.dart';
import 'package:wandercrew/service/razorpay_web.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/edit_text.dart';
import '../../../widgets/elevated_container.dart';
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
                          GoRouter.of(context).canPop()
                              ? IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    context
                                        .pop(); // Go back if there's a previous route
                                  },
                                )
                              : SizedBox.shrink(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      onChanged: (value) =>
                                          controller.SearchFilterOrderItems(
                                              value), // Call the search function
                                      decoration: InputDecoration(
                                        hintText:
                                            "Search by name, number, orderId",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        prefixIcon: Icon(Icons.search,
                                            color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Color(0xffEDCC23)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Color(0xffEDCC23)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Color(0xffEDCC23)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Stack(
                                  children: [
                                    Obx(() {
                                      // Only show the circle if there are active filters
                                      if (controller.activeFilterCount.value >
                                          0) {
                                        return Positioned(
                                          right:
                                              4, // Adjust this to position it properly
                                          top:
                                              -2, // Adjust this to position it properly
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              controller.activeFilterCount.value
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox
                                            .shrink(); // Return empty widget if no filters are active
                                      }
                                    }),
                                    AppElevatedButton(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      width: 40,
                                      showBorder: true,
                                      backgroundColor: Colors.transparent,
                                      borderColor: Color(0xffEDCC23),
                                      borderWidth: 1,
                                      titleTextColor: Colors.black,
                                      child: Icon(Icons.filter_alt,
                                          color: Colors.black, size: 22),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return OrderFilterAlert();
                                            });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxis/Alignment: CrossAxisAlignment.start,
                                children: [
                                  FilterButton(
                                    label: "All",
                                    isSelected:
                                        controller.selectedFilter.value ==
                                            "All",
                                    onTap: () {
                                      controller.filterOrdersByStatus(
                                          label: "All");
                                    },
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  FilterButton(
                                    label: "Pending",
                                    isSelected:
                                        controller.selectedFilter.value ==
                                            "Pending",
                                    onTap: () {
                                      controller.filterOrdersByStatus(
                                          label: "Pending");
                                    },
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  FilterButton(
                                    label: "Processing",
                                    isSelected:
                                        controller.selectedFilter.value ==
                                            "Processing",
                                    onTap: () {
                                      controller.filterOrdersByStatus(
                                          label: "Processing");
                                    },
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  FilterButton(
                                    label: "Completed",
                                    isSelected:
                                        controller.selectedFilter.value ==
                                            'Completed',
                                    onTap: () {
                                      controller.filterOrdersByStatus(
                                          label: "Completed");
                                    },
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  FilterButton(
                                    label: "Refund",
                                    isSelected:
                                        controller.selectedFilter.value ==
                                            'Refund',
                                    onTap: () {
                                      controller.filterOrdersByStatus(
                                          label: "Refund");
                                    },
                                  ),
                                ],
                              ),
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
                                  markAsConfirm: () => controller.confirmOrder(
                                      context, orderData, "Admin"),
                                  markAsDelivered: () =>
                                      controller.orderDelivered(
                                          context, orderData, "Admin"),
                                  orderData: orderData,
                                  initiateRefund: () {
                                    if (orderData.refundAmount != null) {
                                      controller.refundAmountController.text =
                                          (orderData.totalAmount.toInt() -
                                                  orderData.refundAmount!)
                                              .toString();
                                    } else {
                                      controller.refundAmountController.text =
                                          orderData.totalAmount.toString();
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context2) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Customize the radius here
                                          ),
                                          backgroundColor: Color(0xffFFFEF9),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20,
                                                          right: 20.0,
                                                          left: 20),
                                                  child: Text(
                                                    "Refund",
                                                    style: AppWidget
                                                        .black20Text600Style(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16,
                                                          right: 20.0,
                                                          left: 20),
                                                  child: ElevatedContainer(
                                                    child: EditText(
                                                      labelFontWeight:
                                                          FontWeight.w600,
                                                      labelText: "Amount",
                                                      hint:
                                                          "Enter Refund Amount",
                                                      controller: controller
                                                          .refundAmountController,
                                                      inputType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AppElevatedButton(
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      title: "Back",
                                                      titleTextColor:
                                                          Colors.black,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      showBorder: true,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    AppElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();

                                                        RazorpayService
                                                            razorpay =
                                                            RazorpayService();
                                                        razorpay.handleRefund(
                                                          context: context,
                                                          paymentId: orderData
                                                              .transactionId,
                                                          refundAmount: int
                                                              .parse(controller
                                                                  .refundAmountController
                                                                  .text),
                                                          orderId: orderData.id,
                                                          orderAmount: orderData
                                                              .totalAmount
                                                              .toInt(),
                                                        );
                                                      },
                                                      title: "Apply",
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 16),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  //controller.confirmOrder(orderData,"Admin");},
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
                      return Expanded(
                          child: Center(
                              child: Text('No completed orders found.')));
                    case 'Pending':
                      return Expanded(
                          child:
                              Center(child: Text('No pending orders found.')));
                    case 'Processing':
                      return Expanded(
                          child: Center(
                              child: Text('No processing orders found.')));
                    case 'Refunded':
                      return Expanded(
                          child:
                              Center(child: Text('No refunded orders found.')));
                    case 'All':
                      return Expanded(
                          child: Center(child: Text('No orders found.')));
                    default:
                      // If no filter is selected (default), show a message for pending and processing orders
                      return Expanded(
                        child: Center(child: Text('No pending found.')),
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
