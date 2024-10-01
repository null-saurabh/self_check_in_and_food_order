import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../cart_screen_controller.dart';

class ApplyCouponWidget extends StatelessWidget {
  final TextEditingController promoCode;
  // final VoidCallback onPressed;
  final Function(String) onPressed;
  const ApplyCouponWidget({
    super.key, required this.promoCode, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartScreenController>();
    return EditText(
      hint: "Voucher Code",
      controller: promoCode,
      showLabel: false,
      onValidate: (value) {
        // print("inside");
        // Call the applyPromoCode function and return the validation message
        return onPressed(value ?? "");
      },

      suffix: AppElevatedButton(
        width:80,
        title: "Apply",
        titleTextColor: Colors.white,
        titleTextSize: 12,
        titleFontWeight: FontWeight.w400,
        onPressed: () {
    print("tyty");
          // Trigger the form validation
          if (controller.cartFormKey.currentState!.validate()) {
            // If the form is valid, clear the promo code field
            promoCode.clear();
          }


          // // Apply the promo code when the button is pressed
          // final validationMessage = onPressed(promoCode.text);
          // print(validationMessage);
          // if (validationMessage == null) {
          //   promoCode.clear(); // Clear the text field if applied successfully
          // }
        },
      ),
    );
  }
}