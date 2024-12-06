import 'package:flutter/material.dart';
import 'package:wandercrew/utils/date_time.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/widget_support.dart';

import '../../../../models/food_order_model.dart';

class SingleOrder extends StatelessWidget {
  final FoodOrderModel orderData;
  final VoidCallback markAsConfirm;
  final VoidCallback markAsDelivered;
  // final VoidCallback initiateRefund;
  final VoidCallback onCallPressed;

  const SingleOrder(
      {super.key,
      required this.orderData,
      required this.markAsConfirm,
      required this.markAsDelivered,
      // required this.initiateRefund,
      required this.onCallPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  // border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Order ID",
                            style: AppWidget.black16Text400Style(),
                          ),
                          Text(
                            "  #${orderData.orderId}",
                            style: AppWidget.black16Text500Style(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        orderData.dinerName,
                        style: AppWidget.black18Text500Style(),
                      ),
                      Row(
                        children: [
                          Text(
                            'Number: ',
                            style: AppWidget.black16Text400Style(),
                          ),
                          Text(
                            orderData.contactNumber,
                            style: AppWidget.black16Text500Style(),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: onCallPressed,
                            child: const Icon(
                              Icons.call,
                              color: Colors.green,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      if (orderData.deliveryAddress.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              'Table/Room: ',
                              style: AppWidget.black16Text400Style(),
                            ),
                            Text(
                              orderData.deliveryAddress,
                              style: AppWidget.black16Text500Style(),
                            ),
                          ],
                        ),
                      if (orderData.specialInstructions != null &&
                          orderData.specialInstructions!.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              'Instruction: ',
                              style: AppWidget.black16Text400Style(),
                            ),
                            Text(
                              orderData.specialInstructions!,
                              style: AppWidget.black16Text500Style(),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        orderData.items
                            .map((item) =>
                                '${item.quantity} x ${item.menuItemName} (${item.price.toStringAsFixed(2)})')
                            .join('\n'),
                        style: AppWidget.black16Text500Style(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if(orderData.isRefunded != null)
                      Row(
                        children: [
                          Text(
                            'Refund: ',
                            style: AppWidget.black16Text400Style(),
                          ),
                          Text(
                            orderData.isRefunded!,
                            style: AppWidget.black16Text500Style(color: Colors.red),
                          ),
                        ],
                      ),
                      if(orderData.refundAmount != null)
                      Row(
                        children: [
                          Text(
                            'Refund Amount: ',
                            style: AppWidget.black16Text400Style(),
                          ),
                          Text(
                            orderData.refundAmount!.toString(),
                            style: AppWidget.black16Text500Style(color: Colors.red),
                          ),
                        ],
                      ),
                      if(orderData.isRefunded != null)
                      const SizedBox(
                        height: 16,
                      ),

                      if(orderData.couponCode != null)
                      Row(
                        children: [
                          Text(
                            'Voucher: ',
                            style: AppWidget.black16Text400Style(),
                          ),
                          Text(
                            orderData.couponCode!,
                            style: AppWidget.black16Text500Style(color: Colors.red),
                          ),
                        ],
                      ),
                      if(orderData.discount != null)
                      Row(
                        children: [
                          Text(
                            'Discount Amount: ',
                            style: AppWidget.black16Text400Style(),
                          ),
                          Text(
                            orderData.discount!.toStringAsFixed(0),
                            style: AppWidget.black16Text500Style(color: Colors.red),
                          ),
                        ],
                      ),
                      if(orderData.couponCode != null || orderData.discount != null)
                      const SizedBox(
                        height: 16,
                      ),

                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text("\u{20B9}${orderData.totalAmount.toString()}",
                                style: AppWidget.black16Text500Style(
                                  color: const Color(0xff2563EB),
                                )),
                            const SizedBox(width: 4,),
                            const VerticalDivider(
                              color: Colors
                                  .black, // You can change the color as needed
                              thickness: 1, // Thickness of the divider
                              width: 8, // The space occupied by the divider
                            ),
                            const SizedBox(width: 4,),

                            Text(
                              DateTimeUtils.formatDateTime(
                                  DateTime.parse(orderData.orderDate),
                                  format: 'dd MMM HH:mm a'),
                              style: AppWidget.black16Text400Style(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            orderData.orderStatusHistory.last.status,
                            style: AppWidget.black16Text500Style(
                                color:
                                    orderData.orderStatusHistory.last.status ==
                                            "Delivered"
                                        ? Colors.green
                                        : orderData.orderStatusHistory.last
                                                    .status ==
                                                "Confirmed"
                                            ? const Color(0xffFFB700)
                                            : Colors.red),
                          ),
                          Text(
                            " (${DateTimeUtils.formatDateTime(orderData.orderStatusHistory.last.updatedTime, format: 'HH:mm a')})",
                            style: AppWidget.black16Text500Style(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          if (orderData.orderStatusHistory.last.status !=
                              "Delivered") ...[
                            AppElevatedButton(
                              backgroundColor: Colors.black,
                              title: orderData.orderStatusHistory.last.status ==
                                      "Pending"
                                  ? "Accept Order"
                                  : orderData.orderStatusHistory.last.status ==
                                          "Confirmed"
                                      ? "Mark as Delivered"
                                      : "Error",
                              titleTextColor: Colors.white,
                              onPressed: () {
                                if (orderData.orderStatusHistory.last.status ==
                                    "Pending") {
                                  markAsConfirm();
                                } else if (orderData
                                        .orderStatusHistory.last.status ==
                                    "Confirmed") {
                                  markAsDelivered();
                                }
                              },
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                          // orderData.isRefunded != null && orderData.isRefunded! == 'complete refund'
                          // ? SizedBox.shrink()
                          // :AppElevatedButton(
                          //   showBorder: true,
                          //   backgroundColor: Colors.transparent,
                          //   title: "Refund",
                          //   titleTextColor: Colors.red,
                          //   onPressed: () {
                          //     initiateRefund();
                          //   },
                          // ),
                        ],
                      )
                    ],
                  ),
                )),
            if(orderData.isRefunded != null || orderData.orderStatusHistory.last.status == "Pending"  || orderData.orderStatusHistory.last.status == "Confirmed" || orderData.orderStatusHistory.last.status ==
            "Delivered")
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: orderData.isRefunded != null
    ? Colors.orange
                      :orderData.orderStatusHistory.last.status == "Pending"
                      ? Colors.red
                      : orderData.orderStatusHistory.last.status == "Confirmed"
                          ? const Color(0xffFFB700) // Yellow for preparing
                          : orderData.orderStatusHistory.last.status ==
                                  "Delivered"
                              ? Colors.green
                              : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  orderData.isRefunded != null
                  ?"Refunded"
                  :orderData.orderStatusHistory.last.status == "Pending"
                      ? "Pending"
                      : orderData.orderStatusHistory.last.status == "Confirmed"
                          ? "Preparing"
                          : orderData.orderStatusHistory.last.status == "Delivered"
                              ? "Completed"
                              : "error",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
