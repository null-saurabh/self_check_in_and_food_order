import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/text_view.dart';
import 'package:wandercrew/widgets/theme_color.dart';

extension DropDownList<T> on List<T> {
  List<DropdownMenuItem<T>> dropDownItem(String Function(T element) name,
      {bool filled = false, Color? textColor}) {
    return map(
          (e) => DropdownMenuItem<T>(
        value: e,
        child: TextView(
          name.call(e),
          fontSize: 13,
          maxLine: 1,
          textColor: textColor ?? ThemeColor.black,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ).toList();
  }

  void toggleValue(T? value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value!);
    }
  }

  String toName(String Function(T e) name) {
    return map((e) => name.call(e)).join(",");
  }
}