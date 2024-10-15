import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/app_date_picker.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/elevated_container.dart';
import '../../../../widgets/widget_support.dart';
import '../admin_order_controller.dart';

class OrderFilterAlert extends StatelessWidget {
  const OrderFilterAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<AdminOrderListController>(
        init: AdminOrderListController(),
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
                                      children: [
                                        AppDatePicker(
                                          controller: controller.filterFromDate,
                                          labelText: "Starting Date",
                                          hintText: "Select Start Date",
                                          validator: Validators.requiredField,
                                        ),
                                        AppDatePicker(
                                          controller: controller.filterToDate,
                                          labelText: "Ending Date",
                                          hintText: "Select expiration date",
                                          validator: Validators.requiredField,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  ElevatedContainer(
                                    child: Column(
                                      children: [
                                        EditText(
                                          labelFontWeight: FontWeight.w600,
                                          labelText: "Min Order Value",
                                          hint: "Enter Min Order Value",
                                          controller:controller.filterMinOrderValue,
                                          inputType: TextInputType.number,
                                        ),
                                        EditText(
                                          labelFontWeight: FontWeight.w600,
                                          labelText: "Max Order Value*",
                                          hint: "Enter Max Order Value",
                                          controller: controller.filterMaxOrderValue,
                                          inputType: TextInputType.number,
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
                                          controller.filterMaxOrderValue.clear();
                                          controller.filterMinOrderValue.clear();
                                          controller.filterToDate.clear();
                                          controller.filterFromDate.clear();
                                          controller.filterOrdersByStatus(label: controller.selectedFilter.value, isFilterButton: true);
                                          controller.activeFilterCount.value = 0;
                                          controller.update();
                                          context.pop();
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

                                          // Check for other filters (Veg and Availability)
                                          if (controller.filterMinOrderValue.text.isNotEmpty) controller.activeFilterCount.value++;
                                          if (controller.filterMaxOrderValue.text.isNotEmpty) controller.activeFilterCount.value++;
                                          controller.update();
                                          context.pop();

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
