import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/widgets/widget_support.dart';

import 'app_elevated_button.dart';
import 'edit_text.dart';
import 'elevated_container.dart';

class EditPopup extends StatelessWidget {
  final String labelText;
  final String hintText;
  final VoidCallback onPressed;
  final TextEditingController controller;

  const EditPopup(
      {super.key, required this.labelText, required this.hintText, required this.onPressed, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12.0), // Customize the radius here
      ),
      backgroundColor: Color(0xffFFFEF9),
      child: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery
                .of(context)
                .size
                .height * 0.68),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
              const EdgeInsets.only(top: 20, right: 20.0, left: 20),
              child: Text(
                "Modify",
                style: AppWidget.black20Text600Style(),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedContainer(
              child: EditText(
                labelFontWeight: FontWeight.w600,
                labelText: labelText,
                hint: hintText,
                controller: controller,
                inputType: TextInputType.number,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  title: "Clear",
                  titleTextColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  showBorder: true,
                ),
                SizedBox(width: 12,),
                AppElevatedButton(
                  onPressed: onPressed,
                  title: "Apply",
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
