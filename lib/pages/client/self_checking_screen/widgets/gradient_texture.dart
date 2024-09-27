import 'package:flutter/material.dart';

class CheckInGradientTexture extends StatelessWidget {
  final Alignment alignment;
  final String assetPath;
  const CheckInGradientTexture({super.key, required this.alignment, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Align(
          alignment: alignment,
          child: Opacity(
            opacity: 0.9, // Adjust opacity as needed
            child: Image.asset(
              assetPath, // Your gradient texture image path
              width: 104, // Adjust size of the gradient
              height: 96,
              fit: BoxFit.cover, // Ensure the image fits well
            ),
          ),
        ),
      );
  }
}
