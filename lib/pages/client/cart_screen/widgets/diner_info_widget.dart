import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/edit_text.dart';

import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/widget_support.dart';
import '../cart_screen_controller.dart';

class CartCustomerInfoWidget extends StatelessWidget {
  const CartCustomerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartScreenController>(
        init: CartScreenController(),
        builder: (controller) {
          return  Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    prefixSize: 71,
                    prefixHeight: 40,
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: AppDropDown(
                        items:
                        controller.countryCodes.map((codeData) {
                          return DropdownMenuItem(
                            value: codeData['code'],
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    codeData['flag'] ??
                                        '', // Default to empty string if flag is null
                                    width: 20,
                                    height: 20,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons
                                          .flag); // Provide a fallback if flag image fails to load
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  SizedBox(
                                    width: 34,
                                    child: Text(
                                      codeData['code']!.removeAllWhitespace,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow
                                          .ellipsis, // Safeguard to handle overflow
                                      maxLines: 1,
                                    ),
                                  ), // Safely use code as text
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChange: (value) {
                          if (value != null) {
                            controller.selectedCountryCode.value =
                                value;
                          } else {}
                        },
                        // value: selfCheckingController.selectedCountryCode.value,
                        value: controller
                            .selectedCountryCode.value.isNotEmpty
                            ? controller.selectedCountryCode.value
                            : '+91',
                        // labelText: "Code",
                        oneSideBorder: true,
                        contentPadding: const EdgeInsets.all(0),
                        height: 39,
                        width: 69,
                        dropDownWidth: 200,
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.4),
                        showSearch: true,
                        searchCtrl: TextEditingController(),
                        searchMatchFn: (item, searchValue) {
                          searchValue = searchValue.toLowerCase();
                          return item.value
                              .toString()
                              .toLowerCase()
                              .contains(searchValue);
                        },
                      ),
                    ),
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
          );
        });
  }
}
