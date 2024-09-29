// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/text_view.dart';
import 'package:wandercrew/widgets/theme_color.dart';

class EditText extends StatelessWidget {
  TextEditingController? controller;
  double? height;
  double? width;
  Widget? prefix;
  Widget? suffix;
  double? suffixSize;
  double? prefixSize;
  double prefixHeight;
  FontWeight? textFontWeight;
  double? textSize;
  String? Function(String? value)? onValidate;
  Function(String?)? onSubmit;
  Function(String?)? onChange;
  TextAlign? textAlign;
  String? hint;
  Color? hintColor;
  Color? textColor;
  Color? labelColor;
  Color? fillColor;
  FontWeight? hintFontWeight;
  FontWeight? labelFontWeight;
  TextInputType? inputType;
  double? hintTextSize;
  int? minLine;
  int? maxLength;
  bool? filled;
  // EdgeInsets? contentPadding;
  int? maxLine;
  String? labelText = "";
  bool? obscureText;
  bool showBorder = false;
  bool showLabel = true;
  double? borderRadius;
  bool showLeading;
  bool enable;
  Color? borderColor;
  String? imagePath;
  bool paddingBottom;

  FocusNode? focusNode;
  Widget? suffixIcon;
  Function()? onTap;
  bool hideError;
  List<TextInputFormatter>? inputformats;

  EditText({
    super.key,
    this.controller,
    this.height = 40,
    this.filled = false,
    this.width,
    this.prefix,
    this.textSize = 16,
    this.suffix,
    this.hideError = false,
    this.maxLength,
    this.borderColor = ThemeColor.grey,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.suffixSize = 24,
    this.prefixSize = 24,
    this.prefixHeight = 40,
    this.hintFontWeight,
    this.obscureText = false,
    this.textFontWeight,
    this.inputType,
    this.showBorder = true,
    this.labelColor = ThemeColor.black,
    this.textColor = ThemeColor.black,
    this.onTap,
    this.onValidate,
    this.hint,
    this.suffixIcon,
    this.inputformats,
    this.paddingBottom = false,
    this.showLeading = false,
    this.labelFontWeight = FontWeight.w500,
    this.labelText = "",
    // this.contentPadding =
    // const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    this.hintColor = ThemeColor.grey,
    this.fillColor = ThemeColor.grey,
    this.hintTextSize = 12,
    this.minLine,
    this.maxLine = 1,
    this.imagePath,
    this.borderRadius = 12,
    this.showLabel = true,
    this.onChange,
    this.onSubmit,
    this.enable = true,
  });
  // {
    // if (prefix != null) {
      // contentPadding ??= const EdgeInsets.only(top: 10, left: 10, right: 10);
    // }
  // }

  RxnString showError = RxnString();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          TextView(
            labelText ?? '',
            textColor: labelColor,
            fontSize: 16,
            fontWeight: labelFontWeight,
          ),
          const SizedBox(
            height: 4,
          ),
        ],
        SizedBox(
          height: 40,
          child: TextFormField(
            // focusNode: focusNode,
            validator: (value) {
              var result = onValidate?.call(value);
              showError.value = result;
              // return showError.value;
              return result;
            },

            readOnly: onTap != null,
            onTap: onTap,
            enabled: enable,
            controller: controller,
            textAlign: textAlign!,

            style: TextStyle(
              fontWeight: textFontWeight,
              color: textColor,
              fontSize: textSize,
              fontFamily: "poppins",
            ),
            keyboardType: inputType ?? TextInputType.name,

            maxLength: maxLength,
            minLines: minLine,

            maxLines: maxLine,
            onFieldSubmitted: onSubmit,
            onChanged: onChange,
            obscureText: obscureText!,
            focusNode: focusNode,

            decoration: InputDecoration(

              isDense: true,
              counterText: "",
              hintText: hint ?? '',
              filled: filled,
              fillColor:fillColor,
              errorStyle: const TextStyle(height: 0.1, fontSize: 0),
              errorMaxLines: 2,
              hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: hintTextSize,
                  fontFamily:"poppins",
                  fontWeight: hintFontWeight),
              suffixIcon: suffix,
              prefixIcon: prefix,
              // contentPadding: contentPadding,
              // suffixIconConstraints:
              // BoxConstraints(maxWidth: suffixSize!, maxHeight: suffixSize!),
              prefixIconConstraints: BoxConstraints(
                  maxWidth: prefixSize!,
                  maxHeight: prefixHeight,
                  minHeight: prefixHeight,
                  minWidth: prefixSize!
              ),
              border: showBorder
                  ? borderColor != null
                  ? border
                  : Get.theme.inputDecorationTheme.border
                  : InputBorder.none,
              enabledBorder: showBorder
                  ? borderColor != null
                  ? border
                  : Get.theme.inputDecorationTheme.enabledBorder
                  : InputBorder.none,
              errorBorder: showBorder
                  ? borderColor != null
                  ? border
                  : Get.theme.inputDecorationTheme.errorBorder
                  : InputBorder.none,
              focusedBorder: showBorder
                  ? borderColor != null
                  ? border
                  : Get.theme.inputDecorationTheme.focusedBorder
                  : InputBorder.none,
              disabledBorder: showBorder
                  ? borderColor != null
                  ? border
                  : Get.theme.inputDecorationTheme.disabledBorder
                  : InputBorder.none,
              focusedErrorBorder: showBorder
                  ? borderColor != null
                  ? border
                  : Get.theme.inputDecorationTheme.focusedErrorBorder
                  : InputBorder.none,
            ),
            inputFormatters: inputformats,
          ),
        ),










        if (!hideError) ...[
          StreamBuilder<String?>(
            stream: showError.stream,
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                                    snapshot.data ?? '',
                                    style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 211, 63, 63),
                                    ),
                                  ),
                  )
                  : const SizedBox(
                height: 0,
              );
            },
          ),
        ],
        // if (showLabel && paddingBottom) ...[
          const SizedBox(
            height: 12,
          ),
        // ],
      ],
    );
  }

  OutlineInputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      borderRadius ?? 12,
    ),
    borderSide: BorderSide(
      color: ThemeColor.grey,
      width: 1,
    ),
  );
}
