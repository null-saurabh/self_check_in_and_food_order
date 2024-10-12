import 'package:flutter/material.dart';

class BackgroundGradientTexture extends StatelessWidget {
  final String assetPath;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? height;
  final double? width;
  const BackgroundGradientTexture({super.key, required this.assetPath, this.top, this.bottom, this.left, this.right, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: Opacity(
          opacity:1, // Adjust opacity as needed
          child: Image.asset(
            assetPath, // Your gradient texture image path
            width: width ?? 180, // Adjust size of the gradient
            height: height ?? 180,
          ),
        ),
      );
  }
}
