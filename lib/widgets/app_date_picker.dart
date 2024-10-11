import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_text.dart';

class AppDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final FormFieldValidator<String>? validator;

  AppDatePicker({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('dd-MMM-yyyy').format(pickedDate); // Formatting the date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: EditText(
          controller: controller,
          labelFontWeight: FontWeight.w600,
          suffix: Icon(Icons.calendar_today,color: Colors.black,),
          suffixSize: 20,
          onValidate: validator,
          labelText: labelText,
          hint: hintText,
          ),
      ),
    );
  }
}
