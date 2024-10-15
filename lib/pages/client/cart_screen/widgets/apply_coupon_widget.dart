import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../cart_screen_controller.dart';

class ApplyCouponWidget extends StatelessWidget {
  final TextEditingController promoCode;
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
        // return onPressed(value ?? "");
        return controller.voucherValidationMessage.value;
      },

      suffix: AppElevatedButton(
        width:80,
        title: "Apply",
        titleTextColor: Colors.white,
        titleTextSize: 12,
        titleFontWeight: FontWeight.w400,
        onPressed: () async{


          // Trigger the form validation

            final result = await onPressed(promoCode.text.trim()); // Await the result

            if (result != null) {
              // Handle the validation message
              controller.voucherValidationMessage.value = result;
              controller.cartFormKey.currentState!.validate();
            } else {
              // If no error, clear the promo code field
              promoCode.clear();
            }


            // If the form is valid, clear the promo code field
            // promoCode.clear();
        },
      ),
    );
  }
}