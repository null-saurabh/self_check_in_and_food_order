import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/widget_support.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final String labelText;
  final String? Function(T?) onValidate;


  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.labelText,
    required this.onValidate
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: AppWidget.textField16Style()),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: DropdownButtonFormField(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: Colors.grey.withOpacity(0.6),
              //     width: 1,
              //   ),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: Colors.grey.withOpacity(0.6),
              //     width: 1,
              //   ),
              // ),
              // disabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: Colors.grey.withOpacity(0.6),
              //     width: 1,
              //   ),
              // ),
              // errorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: Colors.grey.withOpacity(0.6),
              //     width: 1,
              //   ),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: Colors.grey.withOpacity(0.6),
              //     width: 1,
              //   ),
              // ),
              // focusedErrorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12),
              //   borderSide: BorderSide(
              //     color: Colors.grey.withOpacity(0.6),
              //     width: 1,
              //   ),
              // ),
              hintText: hintText,
              hintStyle: AppWidget.opaque16TextStyle(),
            ),
            dropdownColor: Colors.white,

            validator: onValidate,

          ),
        ),
      ],
    );
  }
}
