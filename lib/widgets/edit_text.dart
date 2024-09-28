// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/text_view.dart';
import 'package:wandercrew/widgets/theme_color.dart';

class EditText extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final Widget? prefix;
  final Widget? suffix;
  final double? suffixSize;
  final double? prefixSize;
  final FontWeight? textFontWeight;
  final double? textSize;
  final String? Function(String? value)? onValidate;
  final Function(String?)? onSubmit;
  final Function(String?)? onChange;
  final TextAlign? textAlign;
  final String? hint;
  final Color? hintColor;
  final Color? textColor;
  final Color? labelColor;
  final Color? fillColor;
  final FontWeight? hintFontWeight;
  final FontWeight? labelFontWeight;
  final TextInputType? inputType;
  final double? hintTextSize;
  final int? minLine;
  final int? maxLength;
  final bool? filled;
  // late final EdgeInsets? contentPadding;
  final int? maxLine;
  final String? labelText;
  final bool? obscureText;
  final bool showBorder;
  final bool showLabel;
  final double? borderRadius;
  final bool showLeading;
  final bool enable;
  final Color? borderColor;
  final String? imagePath;
  final bool paddingBottom;

  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Function()? onTap;
  final bool hideError;
  final List<TextInputFormatter>? F;

  EditText(
      {super.key,
      this.controller,
      this.height,
      this.width,
      this.prefix,
      this.suffix,
      this.suffixSize,
      this.prefixSize,
      this.textFontWeight,
      this.textSize,
      this.onValidate,
      this.onSubmit,
      this.onChange,
      this.textAlign,
      this.hint,
      this.hintColor,
      this.textColor,
      this.labelColor,
      this.fillColor,
      this.hintFontWeight,
      this.labelFontWeight,
      this.inputType,
      this.hintTextSize,
      this.minLine,
      this.maxLength,
      this.filled,
      this.maxLine,
      this.labelText,
      this.obscureText,
      required this.showBorder,
      this.showLabel = false,
      this.borderRadius,
      this.showLeading = false,
      this.enable = false,
      this.borderColor,
      this.imagePath,
      this.paddingBottom = false,
      this.focusNode,
      this.suffixIcon,
      this.onTap,
      this.hideError = false,
      this.F});
  // {
  //   if (prefix != null) {
  //     contentPadding ??= const EdgeInsets.only(top: 10, left: 10, right: 10);
  //   }
  // }

  final RxnString showError = RxnString();

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
            fontSize: 14,
            fontWeight: labelFontWeight,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
        TextFormField(
          // focusNode: focusNode,
          validator: (value) {
            var result = onValidate?.call(value);
            showError.value = result;
            return showError.value;
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
            fillColor: fillColor,
            errorStyle: const TextStyle(height: 0.1, fontSize: 0),
            errorMaxLines: 2,
            hintStyle: TextStyle(
                color: hintColor,
                fontSize: hintTextSize,
                fontFamily: "poppins",
                fontWeight: hintFontWeight),
            suffixIcon: suffix,
            prefixIcon: prefix,
            // contentPadding: contentPadding,
            suffixIconConstraints:
                BoxConstraints(maxWidth: suffixSize!, maxHeight: suffixSize!),
            prefixIconConstraints: BoxConstraints(
                maxWidth: prefixSize!,
                maxHeight: prefixSize!,
                minHeight: prefixSize!,
                minWidth: prefixSize!),
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
          inputFormatters: F,
        ),
        if (!hideError) ...[
          StreamBuilder<String?>(
            stream: showError.stream,
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 211, 63, 63),
                      ),
                    )
                  : const SizedBox(
                      height: 13,
                    );
            },
          ),
        ],
        if (showLabel && paddingBottom) ...[
          const SizedBox(
            height: 5,
          ),
        ],
      ],
    );
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? 10,
        ),
        borderSide: const BorderSide(
          color: ThemeColor.grey,
          width: .5,
        ),
      );
}
