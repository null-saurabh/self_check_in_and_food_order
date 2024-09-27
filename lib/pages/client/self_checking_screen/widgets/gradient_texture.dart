import 'package:flutter/material.dart';

class CheckInGradientTexture extends StatelessWidget {
  final String assetPath;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  const CheckInGradientTexture({super.key, required this.assetPath, this.top, this.bottom, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: Opacity(
          opacity: 0.9, // Adjust opacity as needed
          child: Image.asset(
            assetPath, // Your gradient texture image path
            width: 180, // Adjust size of the gradient
            height: 180,
          ),
        ),
      );
  }
}
