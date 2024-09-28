// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/text_view.dart';
import 'package:wandercrew/widgets/theme_color.dart';

import 'edit_text.dart';

class AppDropDown<T> extends StatelessWidget {
  final T? value;
  final String? selectedValue;
  final Function(T? value)? onChange;
  final List<DropdownMenuItem<T>> items;
  final double? width;
  final double? dropDownWidth;
  final double? height;
  final bool? filled;
  final Color? fillColor;
  final bool showBorder;
  final bool showErrorPadding;

  final String? hintText;
  final EdgeInsets? contentPadding;
  final Color? borderColor;
  final Color? labelColor;
  final Color? textColor;
  final bool showLabel;
  final String? labelText;
  final bool paddingBottom;
  final double? iconSize;
  final double? borderRadius;
  final Color? iconColor;
  final bool showSearch;
  final String? Function(T? value)? onValidate;
  final bool Function(DropdownMenuItem<T> item, String searchValue)?
      searchMatchFn;
  final TextEditingController? searchCtrl;
  final Color? dropDownColor;
  final FocusNode? focusNode;
  final bool showIndiactionTop;
  final bool hideError;

  AppDropDown({
    super.key,
    this.value,
    this.showLabel = false,
    this.onChange,
    required this.items,
    // this.borderColor = ThemeColor.dividerColor,
    this.borderColor = ThemeColor.grey,
    this.showBorder = true,
    this.filled,
    this.height,
    this.contentPadding,
    this.hintText,
    this.hideError = false,
    this.labelText = "",
    this.paddingBottom = false,
    this.dropDownColor,
    this.width,
    this.borderRadius,
    this.dropDownWidth,
    this.iconColor,
    this.iconSize,
    this.labelColor,
    this.textColor,
    this.showSearch = false,
    this.showErrorPadding = true,
    this.onValidate,
    this.focusNode,
    this.searchCtrl,
    this.searchMatchFn,
    this.showIndiactionTop = false,
    this.fillColor,
    this.selectedValue,
  });

  final RxnString showError = RxnString();
  final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText!.isNotEmpty || showLabel) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextView(
                labelText ?? '',
                textColor: labelColor ?? ThemeColor.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
        ],
        SizedBox(
          width: width,
          child: DropdownButtonFormField2<T>(
            style: TextStyle(
              color: textColor ?? ThemeColor.black,
            ),
            items: items,
            onChanged: onChange,
            focusNode: searchFocusNode,
            autofocus: true,
            value: value,
            validator: (value) {
              var result = onValidate?.call(value);
              showError.value = result;

              return result;
            },
            onSaved: onChange,
            hint: TextView(
              hintText ?? '',
              fontSize: 12,
              textColor: textColor ?? ThemeColor.black,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              errorStyle: TextStyle(height: 0.1, fontSize: 0),
              errorMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                color: filled! ? fillColor : Colors.white,
                border: showBorder
                    ? Border.all(
                        color: borderColor ?? ThemeColor.grey,
                        width: .5)
                    : const Border(),
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
              ),
              height: height,
              width: width,
              padding: contentPadding ??
                  const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: iconColor ?? ThemeColor.black,
              ),
              openMenuIcon: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: iconColor ?? ThemeColor.black,
              ),
            ),
            dropdownSearchData: showSearch
                ? DropdownSearchData(
                    searchInnerWidget: Container(
                      height: 90,
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: EditText(
                        // focusNode: searchFocusNode,
                        showBorder: true,
                        height: 45,
                        controller: searchCtrl,
                      ),
                    ),
                    searchController: searchCtrl,
                    searchInnerWidgetHeight: 45,
                    searchMatchFn: searchMatchFn,
                  )
                : null,
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: dropDownWidth ?? width,
              elevation: 1,
              decoration: BoxDecoration(
                color: filled! ? dropDownColor : Colors.white,
              ),
            ),
            isExpanded: true,
          ),
        ),
        if (!hideError)
          StreamBuilder<String?>(
            stream: showError.stream,
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 252, 70, 70),
                      ),
                    )
                  : SizedBox(
                      height: showErrorPadding ? 14 : 0,
                    );
            },
          ),
        if (showLabel && paddingBottom) ...[
          const SizedBox(
            height: 5,
          ),
        ],
      ],
    );
  }

  InputBorder getBorder() {
    return showBorder
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? ThemeColor.grey,
            ),
          )
        : InputBorder.none;
  }
}
