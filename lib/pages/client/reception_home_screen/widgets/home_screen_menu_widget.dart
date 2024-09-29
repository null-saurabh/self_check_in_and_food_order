import 'package:flutter/material.dart';

import '../../../../widgets/widget_support.dart';

class ReceptionHomeGridItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const ReceptionHomeGridItem({super.key,
    required this.icon, required this.label, required this.onTap
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
        width: 148,
        height: 168, // Fixed size for each grid item
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon, // Load the asset image
              width: 86,
              height: 86,
            ), // Icon in the center
            const SizedBox(height: 12),
            Text(
              label,
              style: AppWidget.light16TextStyle(),
            ), // Text below the icon
          ],
        ),
      ),
    );
  }
}
