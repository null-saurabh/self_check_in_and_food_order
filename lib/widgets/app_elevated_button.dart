// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/widgets/text_view.dart';
import 'package:wandercrew/widgets/theme_color.dart';

class AppElevatedButton extends StatelessWidget {
  Widget? child;
  String? title;
  VoidCallback? onPressed;
  Color? backgroundColor;
  Color? titleTextColor;
  Color? borderColor;
  Color? disableColor;
  double? width;
  double? height;
  double? titleTextSize;
  double? borderWidth;
  double? borderRadius;
  double? elevation;
  EdgeInsets? contentPadding;
  Alignment childAlign;
  bool? showBorder;
  FontWeight? titleFontWeight;

  AppElevatedButton({
    Key? key,
    this.child,
    this.title,
    this.onPressed,
    this.backgroundColor,
    this.titleTextColor = Colors.white,
    this.disableColor,
    this.showBorder = false,
    this.borderColor,
    this.width,
    this.height,
    this.childAlign = Alignment.center,
    this.titleTextSize = 12,
    this.borderWidth = 0,
    this.borderRadius = 12,
    this.elevation = 0,
    this.contentPadding,
    this.titleFontWeight = FontWeight.w600,
  }) : super(key: key) {
    height ??= 40;
    backgroundColor ??=  ThemeColor.black;
    borderColor ??= ThemeColor.black;
    // borderColor ??= AppService.instance.currentTheme.value.colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed != null
            ? () {
                if (Get.isSnackbarOpen) {
                  context.pop();
                }
                onPressed?.call();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          alignment: childAlign,
          disabledBackgroundColor: disableColor ?? ThemeColor.disableColor,
          elevation: elevation,
          padding: contentPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            side: showBorder!
                ? BorderSide(color: borderColor!, width: borderWidth!)
                : BorderSide.none,
          ),
        ),
        child: child ??
            TextView(
              title ?? '',
              textColor: titleTextColor,
              fontSize: titleTextSize,
              fontWeight: titleFontWeight,
              maxLine: 1,
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}
