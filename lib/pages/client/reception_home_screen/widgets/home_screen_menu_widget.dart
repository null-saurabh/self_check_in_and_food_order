import 'package:flutter/material.dart';

import '../../../../widgets/widget_support.dart';

class ReceptionHomeGridItem extends StatelessWidget {
  final String? icon;
  final Widget? labelIcon;
  final String label;
  final VoidCallback onTap;
  final double height;
  final double iconWidth;
  final double iconHeight;
  final bool? isRoomService;
  final bool? isCheckIn;
  const ReceptionHomeGridItem({super.key,
    this.icon, required this.label, required this.onTap, required this.height, this.iconWidth = 86, this.iconHeight = 86, this.labelIcon, this.isRoomService, this.isCheckIn,
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
        width: 168,
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: isRoomService!= null && isRoomService! ? MainAxisAlignment.center :MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              if(icon != null) ...[
              Image.asset(
                icon!, // Load the asset image
                width: iconWidth,
                height: iconHeight,
              ), // Icon in the center
              // const SizedBox(height: 12),
                if(isCheckIn!= null && isCheckIn!) const Spacer(),

              ],
              if(isRoomService == null && isCheckIn == null)
                const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if(labelIcon != null) ...[
                  labelIcon!,
                  const SizedBox(width: 4,)],
                  Text(
                    label,
                    style: AppWidget.textField16Style(),
                  ),
                  if(isCheckIn != null && isCheckIn!) const SizedBox(height: 80,)
                ],
              ), // Text below the icon
            ],
          ),
        ),
      ),
    );
  }
}
