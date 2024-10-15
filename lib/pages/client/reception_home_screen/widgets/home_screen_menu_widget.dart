import 'package:flutter/material.dart';

import '../../../../widgets/widget_support.dart';

class ReceptionHomeGridItem extends StatelessWidget {
  final String? icon;
  final Widget? labelIcon;
  final String label;
  final VoidCallback onTap;
  final double height;
  final double? width;
  final double iconWidth;
  final double iconHeight;
  final bool? isRoomService;
  final bool? isCheckIn;
  final bool? isFeedbackList;
  final bool? isTrackOrder;
  final double? widthRatio;
  const ReceptionHomeGridItem({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    required this.height,
    this.iconWidth = 86,
    this.iconHeight = 86,
    this.labelIcon,
    this.isRoomService,
    this.isCheckIn,
    this.width,
    this.isFeedbackList,
    this.widthRatio, this.isTrackOrder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle the tap event
      child: Container(
        // constraints: BoxConstraints(
        //   maxWidth: 148,
        //   maxHeight: 168,
        //     minHeight: 108,
        //     minWidth: 128
        // ),
        width: width != null
            ? (MediaQuery.of(context).size.width * widthRatio!) > width!
                ? width
                : MediaQuery.of(context).size.width * widthRatio!
            : ((MediaQuery.of(context).size.width * 0.45) > 168
                ? 168
                : MediaQuery.of(context).size.width * 0.45),
        height: height, // Fixed size for each grid item
        decoration: BoxDecoration(
          color: Colors.white, // Elevated white box
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Shadow effect
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: isRoomService != null && isRoomService!
                ? MainAxisAlignment.center
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(isCheckIn != null)
                SizedBox(height: 4,),
              if (icon != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      icon!, // Load the asset image
                      width: iconWidth,
                      height: iconHeight,
                    ),
                    if (isFeedbackList != null)
                      SizedBox(
                        width: 8,
                      ),
                    if (isFeedbackList != null)
                      Text(
                        label,
                        style: AppWidget.textField16Style(),
                      ),
                  ],
                ), // Icon in the center
                // const SizedBox(height: 12),
                if (isCheckIn != null && isCheckIn!) const Spacer(),
              ],
              if (isRoomService == null &&
                  isCheckIn == null &&
                  isFeedbackList == null && isTrackOrder == null)
                const SizedBox(height: 18),
              if (isFeedbackList == null && isTrackOrder == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (labelIcon != null) ...[
                      labelIcon!,
                      const SizedBox(
                        width: 4,
                      )
                    ],
                    Text(
                      label,
                      style: AppWidget.textField16Style(),
                    ),
                    if (isCheckIn != null && isCheckIn!)
                      const SizedBox(
                        height: 80,
                      )
                  ],
                ), // Text below the icon
            ],
          ),
        ),
      ),
    );
  }
}
