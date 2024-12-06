
import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/text_view.dart';
import 'package:wandercrew/widgets/theme_color.dart';

import 'app_elevated_button.dart';
import 'custom_dialog_widget.dart';
import 'dialog_widget.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({super.key});

  // var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("inside confirm");

    return CustomDialogWidget(
      dialogTitle: "Are you sure you want to delete?",
      showClose: false,
      onCloseClick: () {
        // Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextView(
                "You Won't Be Able To Revert This!",
                textColor: Colors.black54,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppElevatedButton(
                      title: "Yes, Delete It!",
                      height: 40,
                      titleTextSize: 14,
                      borderColor: Colors.transparent,
                      titleTextColor: Colors.white,
                      backgroundColor: const Color(0xFF3085d6),
                      onPressed: () {
                        // Navigator.pop(context, true);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: AppElevatedButton(
                      title: "Cancel",
                      height: 40,
                      titleTextSize: 14,
                      titleTextColor: Colors.white,
                      backgroundColor: Colors.red,
                      onPressed: () {
                        // Navigator.pop(context, false);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
