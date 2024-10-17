import 'package:flutter/material.dart';
import 'package:wandercrew/utils/date_time.dart';
import 'package:wandercrew/widgets/elevated_container.dart';

import '../../../../models/food_order_model.dart';
import '../../../../widgets/widget_support.dart';

class TrackItemWidget extends StatelessWidget {
  final FoodOrderModel orderData;
  const TrackItemWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        ElevatedContainer(
            child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Summary", style: AppWidget.black20Text600Style()),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  'Order ID  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text(
                  "#${orderData.orderId}",
                  style: AppWidget.black16Text400Style(),
                ),

              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              orderData.dinerName,
              style: AppWidget.black18Text500Style(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Items:  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text(
                  orderData.items
                      .map((item) =>
                  '${item.quantity} x ${item.menuItemName} (${item.price.toStringAsFixed(2)})')
                      .join('\n'),
                  style: AppWidget.black16Text400Style(),
                ),
              ],
            ),
            if(orderData.discount != null) ...[
              SizedBox(height: 8,),
            Row(
              children: [
                Text(
                  'Discount:  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text("- \u{20B9}${orderData.discount.toString()}",
                    style: AppWidget.black16Text400Style()),
              ],
            ),],
            if(orderData.discount != null) ...[
              SizedBox(height: 8,),
              Row(
                children: [
                  Text(
                    'Discount:  ',
                    style: AppWidget.black16Text600Style(),
                  ),
                  Text("- \u{20B9}${orderData.discount.toString()}",
                      style: AppWidget.black16Text400Style()),
                ],
              ),
            ],
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Total Cost:  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text("\u{20B9}${orderData.totalAmount.toString()}",
                    style: AppWidget.black16Text400Style()),
              ],
            ),
          ],
        )),
        SizedBox(height: 8,),
        ElevatedContainer(child: Column(
          children: [

            Row(
              children: [
                Text(
                  'Current Status:  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text(
                  orderData.isRefunded != null ? "Refunded" : orderData.orderStatusHistory.last.status ,
                  style: AppWidget.black16Text400Style(
                      color: orderData.isRefunded != null
                  ? Colors.orange
                      :orderData.orderStatusHistory.last.status ==
                      "Delivered"
                      ? Colors.green
                      : orderData.orderStatusHistory.last
                      .status ==
                      "Confirmed"
                      ? Color(0xffFFB700)
                      : Colors.red),
                ),

              ],
            ),
            if(orderData.refundAmount != null)
            Row(
              children: [
                Text(
                  'Refund Amount:  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text(
                  orderData.refundAmount.toString(),
                  style: AppWidget.black16Text400Style(),
                ),
              ],
            ),
            if(orderData.updatedAt != null || orderData.createdAt != null)
            Row(
              children: [
                Text(
                  'Last Updated:  ',
                  style: AppWidget.black16Text600Style(),
                ),
                Text(
                  DateTimeUtils.formatDateTime(orderData.updatedAt ?? orderData.createdAt!, format: 'hh:mm a') ,
                  style: AppWidget.black16Text400Style(),
                ),
              ],
            ),
          ],
        )),
        SizedBox(height: 20,),
      ],
    );
  }
}
