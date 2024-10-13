import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_date_picker.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/elevated_container.dart';
import '../../../../widgets/widget_support.dart';
import '../manage_voucher_controller.dart';


class VoucherFilterAlert extends StatelessWidget {
  const VoucherFilterAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ManageVoucherAdminController>(
        init: ManageVoucherAdminController(),
        builder: (controller) {
          return  Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12.0), // Customize the radius here
            ),
            backgroundColor: Color(0xffFFFEF9),
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.68),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, right: 20.0, left: 20),
                    child: Text(
                      "Filter",
                      style: AppWidget.black20Text600Style(),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: controller.scrollController,
                      thumbVisibility:
                      true, // Set to false to only show the scrollbar when scrolling
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, right: 20.0, left: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                                    .contains('single-use'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedVoucherType.add('single-use');
                                                  } else {
                                                    controller.selectedVoucherType.remove('single-use');
                                                  }
                                                  // controller.update();
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
                                                    .contains('multi-use'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedVoucherType.add('multi-use');
                                                  } else {
                                                    controller.selectedVoucherType.remove('multi-use');
                                                  }
                                                  // controller.update();
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
                                                    .contains('value-based'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedVoucherType.add('value-based');
                                                  } else {
                                                    controller.selectedVoucherType.remove('value-based');
                                                  }
                                                  // controller.update();
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
                              SizedBox(height: 16,),
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
                                                    .contains('percentage'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedDiscountType.add('percentage');
                                                  } else {
                                                    controller.selectedDiscountType.remove('percentage');
                                                  }
                                                  // controller.update();
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
                                                    .contains('fixed-discount'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedDiscountType.add('fixed-discount');
                                                  } else {
                                                    controller.selectedDiscountType.remove('fixed-discount');
                                                  }
                                                  // controller.update();
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
                              SizedBox(height: 16,),
                              ElevatedContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Heading for Voucher Type
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "Category",
                                        style: AppWidget.black16Text600Style(),
                                      ),
                                    ),
                                    Obx(() {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: controller.selectedCategory.contains('Food Voucher'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedCategory.add('Food Voucher');
                                                  } else {
                                                    controller.selectedCategory.remove('Food Voucher');
                                                  }
                                                  // controller.update();
                                                },
                                                checkColor: Colors.white,
                                                activeColor: Color(0xff2563EB),
                                              ),
                                              Text(
                                                "Food Voucher",
                                                style:
                                                AppWidget.black12Text500Style(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: controller
                                                    .selectedCategory
                                                    .contains('Room Voucher'),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    controller.selectedCategory.add('Room Voucher');
                                                  } else {
                                                    controller.selectedCategory.remove('Room Voucher');
                                                  }
                                                  // controller.update();
                                                },
                                                checkColor: Colors.white,
                                                activeColor: Color(0xff2563EB),
                                              ),
                                              Text(
                                                "Room Voucher",
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
                              SizedBox(height: 16,),

                              ElevatedContainer(
                                child: Column(
                                  children: [
                                    AppDatePicker(
                                      controller: controller.filterFromDate,
                                      labelText: "From Date",
                                      hintText: "Select Start Date",
                                      validator: Validators.requiredField,
                                    ),
                                    AppDatePicker(
                                      controller: controller.filterToDate,
                                      labelText: "To Date",
                                      hintText: "Select expiration date",
                                      validator: Validators.requiredField,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppElevatedButton(
                                    onPressed: (){
                                      controller.filterToDate.clear();
                                      controller.filterFromDate.clear();
                                      controller.selectedCategory.clear();
                                      controller.selectedDiscountType.clear();
                                      controller.selectedVoucherType.clear();
                                      controller.filterOrdersByStatus(label: controller.selectedFilter.value, isFilterButton: true);
                                      controller.activeFilterCount.value = 0;
                                      controller.update();
                                      Get.back();
                                    },
                                    title: "Clear",
                                    titleTextColor: Colors.black,
                                    backgroundColor: Colors.transparent,
                                    showBorder: true,
                                  ),
                                  SizedBox(width: 12,),

                                  AppElevatedButton(
                                    onPressed: (){
                                      controller.filterOrdersByStatus(label: controller.selectedFilter.value,isFilterButton: true);
                                      controller.activeFilterCount.value = 0;
                                      if (controller.filterFromDate.text.isNotEmpty) controller.activeFilterCount.value++;
                                      if (controller.filterToDate.text.isNotEmpty) controller.activeFilterCount++;
                                      if (controller.selectedCategory.isNotEmpty) controller.activeFilterCount++;
                                      if (controller.selectedDiscountType.isNotEmpty) controller.activeFilterCount++;
                                      if (controller.selectedVoucherType.isNotEmpty) controller.activeFilterCount++;

                                      controller.update();
                                      Get.back();

                                    },
                                    title: "Apply",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );

        }
    );
  }
}
