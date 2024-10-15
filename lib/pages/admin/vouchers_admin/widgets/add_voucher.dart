import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/manage_voucher_controller.dart';

import '../../../../models/voucher_model.dart';
import '../../../../widgets/app_date_picker.dart';
import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/elevated_container.dart';
import '../../../../widgets/widget_support.dart';
import 'add_voucher_controller.dart';

class AddVoucherAdmin extends StatelessWidget {
  final bool isEdit;
  final CouponModel? data;
  const AddVoucherAdmin({super.key, this.isEdit = false, this.data});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVoucherAdminController>(
      init: AddVoucherAdminController(data: data),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xffFFFEF9),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 46, bottom: 0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Food',
                              style: AppWidget.black24Text600Style(
                                      color: Color(0xffE7C64E))
                                  .copyWith(height: 1),
                            ),
                            Text(
                              'Voucher',
                              style: AppWidget.black24Text600Style()
                                  .copyWith(height: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8,)
                  ]),
                ),
              ),
              const SizedBox(height: 12.0),
              // First container with mandatory fields
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          ElevatedContainer(
                            child: EditText(
                              labelFontWeight: FontWeight.w600,
                              labelText: "Voucher Code*",
                              hint: "Voucher Code",
                              controller: controller.voucherCodeController,
                              onValidate: (value) {
                                // Check if the field is empty
                                if (value == null || value.trim().isEmpty) {
                                  return 'Voucher is required';
                                }
                                var voucherController = Get.find<ManageVoucherAdminController>();
                                // Check if the username already exists in userDataList
                                if(controller.isEditing.value == false){
                                if ( voucherController.voucherList.any((voucher) => voucher.code == value.trim())) {
                                  return 'Voucher already exists';
                                }
                                return null; // Return null if validation passes
                              }
                                return null;
                                },
                              suffixWidget: AppElevatedButton(
                                onPressed: () {
                                  String generatedCode =
                                      controller.generateVoucherCode(
                                          8); // Generate 8-char code
                                  controller.voucherCodeController.text =
                                      generatedCode; // Set to the controller
                                },
                                title: "Auto Generate",
                                titleTextColor: Colors.white,
                                contentPadding: EdgeInsets.all(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelFontWeight: FontWeight.w600,
                              labelText: "Title*",
                              hint: "Enter Voucher Title",
                              controller: controller.titleController,
                              onValidate: Validators.requiredField,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Heading for Voucher Type
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "Voucher Type",
                                    style: AppWidget.black16Text600Style(),
                                  ),
                                ),
                                Obx(() {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: controller
                                                    .selectedVoucherType
                                                    .value ==
                                                'single-use',
                                            onChanged: (bool? value) {
                                              controller.selectedVoucherType
                                                  .value = 'single-use';
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff2563EB),
                                          ),
                                          Text(
                                            "Single Use",
                                            style:
                                                AppWidget.black12Text500Style(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: controller
                                                    .selectedVoucherType
                                                    .value ==
                                                'multi-use',
                                            onChanged: (bool? value) {
                                              controller.selectedVoucherType
                                                  .value = 'multi-use';
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff2563EB),
                                          ),
                                          Text(
                                            "Multi Use",
                                            style:
                                                AppWidget.black12Text500Style(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: controller
                                                    .selectedVoucherType
                                                    .value ==
                                                'value-based',
                                            onChanged: (bool? value) {
                                              controller.selectedVoucherType
                                                  .value = 'value-based';
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff2563EB),
                                          ),
                                          Text(
                                            "Value Based",
                                            style:
                                                AppWidget.black12Text500Style(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),

                                // Heading for Discount Type
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Heading for Voucher Type
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "Discount Type",
                                    style: AppWidget.black16Text600Style(),
                                  ),
                                ),
                                Obx(() {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: controller
                                                    .selectedDiscountType
                                                    .value ==
                                                'percentage',
                                            onChanged: (bool? value) {
                                              controller.selectedDiscountType
                                                  .value = 'percentage';
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff2563EB),
                                          ),
                                          Text(
                                            "Percentage Discount (%)",
                                            style:
                                                AppWidget.black12Text500Style(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: controller
                                                    .selectedDiscountType
                                                    .value ==
                                                'fixed-discount',
                                            onChanged: (bool? value) {
                                              controller.selectedDiscountType
                                                  .value = 'fixed-discount';
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff2563EB),
                                          ),
                                          Text(
                                            "Fixed Discount (\u{20B9})",
                                            style:
                                                AppWidget.black12Text500Style(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),

                                // Heading for Discount Type
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          ElevatedContainer(
                            child: Obx(() {
                              return AppDropDown(
                                items: ['Food Voucher', 'Room Voucher']
                                    .map((type) {
                                  return DropdownMenuItem(
                                      value: type, child: Text(type));
                                }).toList(),
                                value: controller.selectedCategories.value,
                                onChange: (value) =>
                                    controller.selectedCategories.value = value,
                                hintText: "Select Categories",
                                labelText: "Applicable Category*",
                                labelFontWeight: FontWeight.w600,
                                showLabel: true,
                                height: 40,
                                iconColor: Colors.grey,
                                // showSearch: true,
                                // searchCtrl: TextEditingController(),
                                // searchMatchFn: (item, searchValue) {
                                //   searchValue = searchValue.toLowerCase();
                                //   return item.value
                                //       .toString()
                                //       .toLowerCase()
                                //       .contains(searchValue);
                                // },
                                onValidate: Validators.requiredField,
                              );
                            }),
                          ),
                          const SizedBox(height: 16.0),

                          Obx(() {
                            return ElevatedContainer(
                              child: Column(
                                children: [
                                  EditText(
                                    labelFontWeight: FontWeight.w600,
                                    labelText: "Discount Value*",
                                    hint: "Enter Discount Value",
                                    controller:
                                        controller.discountValueController,
                                    onValidate: Validators.validateInt,
                                    inputType: TextInputType.number,
                                  ),
                                  if (controller.selectedVoucherType.value ==
                                      "value-based" && controller.isEditing.value)
                                    EditText(
                                      labelFontWeight: FontWeight.w600,
                                      labelText: "Remaining value*",
                                      hint: "Enter Remaining Value",
                                      controller: controller
                                          .remainingDiscountValueController,
                                      onValidate: Validators.validateInt,
                                      inputType: TextInputType.number,
                                    ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 16.0),
                          Obx(() {
                            return ElevatedContainer(
                              child: Column(
                                children: [
                                  EditText(
                                    labelFontWeight: FontWeight.w600,
                                    labelText: "Min Order Value",
                                    hint: "Enter Min Order Value",
                                    controller:
                                        controller.minOrderValueController,
                                  ),
                                  if (controller.selectedDiscountType.value ==
                                      "percentage")
                                    EditText(
                                      labelFontWeight: FontWeight.w600,
                                      labelText: "Maximum Discount*",
                                      hint: "Enter Max Discount",
                                      controller:
                                          controller.maxDiscountController,
                                      onValidate: Validators.validateInt,
                                      inputType: TextInputType.number,
                                    ),
                                  if (controller.selectedVoucherType.value ==
                                      "multi-use")
                                    EditText(
                                      labelFontWeight: FontWeight.w600,
                                      labelText: "Max Usage Limit*",
                                      hint: "Enter number of usage",
                                      controller: controller.maxLimitController,
                                      onValidate: Validators.validateInt,
                                      inputType: TextInputType.number,
                                    ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 16.0),

                          ElevatedContainer(
                            child: Column(
                              children: [
                                AppDatePicker(
                                  controller: controller.validFromController,
                                  labelText: "Valid From",
                                  hintText: "Select Start Date",
                                  validator: Validators.requiredField,
                                ),
                                AppDatePicker(
                                  controller:
                                      controller.expirationDateController,
                                  labelText: "Expiration Date",
                                  hintText: "Select expiration date",
                                  validator: Validators.requiredField,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20.0),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppElevatedButton(
                                onPressed: () {
                                  context.pop(); // Cancel action
                                },
                                showBorder: true,
                                backgroundColor: Colors.transparent,
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              AppElevatedButton(
                                onPressed: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.submitCouponData(context);
                                  }
                                },
                                backgroundColor: Colors.black,
                                child: Text(
                                  isEdit ? "Save" : "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
