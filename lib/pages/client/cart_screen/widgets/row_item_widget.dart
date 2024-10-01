import 'package:flutter/material.dart';

import '../../../../widgets/widget_support.dart';

class CartRowItemWidget extends StatelessWidget {
  final double amount;
  final String label;
  final bool isBold;
  final bool isCoupon;
  final VoidCallback? onPressed;
  const CartRowItemWidget({
    super.key,
    required this.amount,
    required this.label,
    this.isBold = false,
    this.isCoupon = false, this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCoupon)
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.close,
                color: Colors.red,
                  size: 16,
              )),
              Text(
                label,
                style: isBold
                    ? AppWidget.black16Text500Style()
                    : AppWidget.black16Text400Style(),
              ),
            ],
          ),

        isCoupon
            ? Text("- \u{20B9}${amount.toStringAsFixed(2)}",
                style: isBold
                    ? AppWidget.black16Text500Style()
                    : AppWidget.black16Text400Style())
            : Text("\u{20B9}${amount.toStringAsFixed(2)}",
                style: isBold
                    ? AppWidget.black16Text500Style()
                    : AppWidget.black16Text400Style())
      ],
    );
  }
}
