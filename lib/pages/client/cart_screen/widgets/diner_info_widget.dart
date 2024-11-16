import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/edit_text.dart';
import '../../../../widgets/widget_support.dart';
import '../cart_screen_controller.dart';

class CartCustomerInfoWidget extends StatelessWidget {
  final CartScreenController controller;
  const CartCustomerInfoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: controller.cartDinnerInfoFormKey,
                child: Column(
                  children: [
                    EditText(
                      hint: "Enter Your Name",
                      controller: controller.dinerName,
                      showLabel: false,
                      onValidate: Validators.requiredField,
                    ),

                    EditText(
                      hint: "Enter Contact Number",
                      showLabel: false,

                      inputType: TextInputType.number,
                      controller: controller.contactNumberController,
                      onValidate: Validators.validatePhoneNumber,
                    ),
                    EditText(

                      hint: "Table/Room Number (optional)",
                      showLabel: false,

                      controller: controller.deliveryAddressController,
                    ),
                    EditText(
                      hint: "Any Special Instruction (optional)",
                      showLabel: false,
                      paddingBottom: false,
                      controller: controller.instructionController,
                    ),
                   ],
                ),
              ),
            ),
          );

  }
}
