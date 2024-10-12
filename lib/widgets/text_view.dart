  // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/theme_color.dart';

class TextView extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign textAlign;
  final int? maxLine;
  final TextOverflow? overflow;
  final double? latterSpacing;
  final double? fontHeight;
  final TextDecoration? decoration;
  // final bool useRoboto = false;

  const TextView(
    this.text, {
    super.key,
    this.fontFamily = "poppins",
    this.fontSize = 14,
    this.fontWeight,
    this.maxLine,
    this.overflow,
    this.fontHeight,
    this.latterSpacing,
    this.decoration,
    // this.useRoboto = false,
    this.textAlign = TextAlign.start,
    this.textColor = ThemeColor.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
          color: textColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
          overflow: overflow,
          fontWeight: fontWeight,
          decoration: decoration,
          height: fontHeight,
          letterSpacing: latterSpacing),
    );
  }
}
