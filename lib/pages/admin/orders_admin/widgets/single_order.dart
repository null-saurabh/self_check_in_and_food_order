import 'package:flutter/material.dart';
import 'package:wandercrew/utils/date_time.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/widget_support.dart';

import '../../../../models/order_model.dart';

class SingleOrder extends StatelessWidget {
  final OrderModel orderData;
  final VoidCallback markAsConfirm;
  final VoidCallback markAsDelivered;
  final VoidCallback initiateRefund;

  const SingleOrder({super.key, required this.orderData, required this.markAsConfirm, required this.markAsDelivered, required this.initiateRefund});

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
                  padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 12),
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
                      SizedBox(height: 8,),
                      Text(
                        orderData.dinerName,
                        style: AppWidget.black20Text500Style(),
                      ),
                      SizedBox(height: 12,),

                      Text(
                        orderData.items
                            .map((item) =>
                                '${item.quantity} x ${item.menuItemName} (${item.price.toStringAsFixed(2)})')
                            .join('\n'),
                        style: AppWidget.black16Text500Style(),
                      ),
                      SizedBox(height: 12,),

                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text("\u{20B9}${orderData.totalAmount.toString()}",style: AppWidget.black16Text500Style(color: Color(0xff2563EB),)),
                            VerticalDivider(
                              color: Colors.black,  // You can change the color as needed
                              thickness: 1,         // Thickness of the divider
                              width: 8,            // The space occupied by the divider
                            ),
                            Text(DateTimeUtils.formatDateTime(DateTime.parse(orderData.orderDate),format: 'dd MMM HH:mm a'),style: AppWidget.black16Text400Style(),),
                            ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(orderData.orderStatusHistory.last.status,style: AppWidget.black16Text500Style(color: orderData.orderStatusHistory.last.status == "Delivered" ? Colors.green : orderData.orderStatusHistory.last.status == "Confirmed" ? Color(0xffFFB700) : Colors.red),),
                          Text(" (${DateTimeUtils.formatDateTime(orderData.orderStatusHistory.last.updatedTime,format: 'HH:mm a')})",style: AppWidget.black16Text500Style(),),

                        ],
                      ),
                      SizedBox(height: 12,),
                      Row(
                        children: [
                          if(orderData.orderStatusHistory.last.status != "Delivered") ...[
                          AppElevatedButton(
                            backgroundColor: Colors.black,
                            title: orderData.orderStatusHistory.last.status == "Pending" ? "Accept Order" : orderData.orderStatusHistory.last.status =="Confirmed" ? "Mark as Delivered" : "Error",
                            titleTextColor: Colors.white,
                            onPressed: (){
                              print("confirm 1");
                              if (orderData.orderStatusHistory.last.status == "Pending") {
                                print("confirm 2");
                                markAsConfirm();
                              } else if(orderData.orderStatusHistory.last.status == "Confirmed") {
                                print("confirm 3");
                                markAsDelivered();
                              }
                            },
                          ),
                          SizedBox(width: 8,),
                          ],
                          AppElevatedButton(
                            showBorder: true,
                            backgroundColor: Colors.transparent,
                            title: "Refund",
                            titleTextColor: Colors.red,
                            onPressed: (){
                              initiateRefund();
                            },
                          ),
                        ],
                      )

                    ],
                  ),
                )

                ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: orderData.orderStatusHistory.last.status == "Pending"
                      ? Colors.red
                      : orderData.orderStatusHistory.last.status == "Confirmed"
                      ? Color(0xffFFB700) // Yellow for preparing
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  orderData.orderStatusHistory.last.status == "Pending"
                      ? "Pending"
                      : orderData.orderStatusHistory.last.status == "Confirmed"
                      ? "Preparing"
                      : "",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,)
          ],
        ),
        SizedBox(height: 12,)
      ],
    );
  }
}
