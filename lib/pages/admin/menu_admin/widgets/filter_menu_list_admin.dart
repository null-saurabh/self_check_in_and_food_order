import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/elevated_container.dart';
import '../../../../widgets/text_view.dart';
import '../../../../widgets/widget_support.dart';
import '../menu_admin_controller.dart';

class FilterMenuListAdmin extends StatelessWidget {
  const FilterMenuListAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<MenuAdminController>(
        init: MenuAdminController(),
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
                                    const TextView(
                                      "Veg/NonVeg",
                                      textColor: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Obx(() { return ChoiceChip(
                                            label:   Text("Veg",style: controller.selectedVegFilter.value == "Veg" ? AppWidget.black14Text600Style():AppWidget.black14Text400Style(),),
                                            backgroundColor: Colors.white,
                                            selectedColor: const Color(0xffECFDFC),
                                            disabledColor: const Color(0xffECFDFC),
                                            selected:
                                            controller.selectedVegFilter.value ==
                                                "Veg",
                                            side: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            onSelected: (isSelected) {
                                              controller.selectedVegFilter.value = isSelected ?"Veg" : null;
                                            });
                                        }),
                                        const SizedBox(width: 8),
                                        Obx(() { return ChoiceChip(
                                          backgroundColor: Colors.white,
                                          label:   Text("Non Veg",style: controller.selectedVegFilter.value == "Non Veg" ? AppWidget.black14Text600Style():AppWidget.black14Text400Style(),),
                                          selectedColor: const Color(0xffECFDFC),
                                          side: const BorderSide(
                                              width: 1, color: Colors.grey),
                                          selected:
                                          controller.selectedVegFilter.value == "Non Veg",
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)),
                                          onSelected: (isSelected) {
                                            controller.selectedVegFilter.value = isSelected ?"Non Veg" : null;
                                          },
                                        );}),
                                      ],
                                    ),



                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextView(
                                      "Availability Status",
                                      textColor: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Obx(() { return ChoiceChip(
                                            label:   Text("On",style: controller.selectedAvailableFilter.value == "On" ? AppWidget.black14Text600Style():AppWidget.black14Text400Style(),),
                                            backgroundColor: Colors.white,
                                            selectedColor: const Color(0xffECFDFC),
                                            disabledColor: const Color(0xffECFDFC),
                                            selected:
                                            controller.selectedAvailableFilter.value ==
                                                "On",
                                            side: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            onSelected: (isSelected) {
                                              controller.selectedAvailableFilter.value = isSelected ?"On" : null;
                                            });
                                        }),
                                        const SizedBox(width: 8),
                                        Obx(() { return ChoiceChip(
                                          backgroundColor: Colors.white,
                                          label:   Text("Off",style: controller.selectedAvailableFilter.value == "Off" ? AppWidget.black14Text600Style():AppWidget.black14Text400Style(),),
                                          selectedColor: const Color(0xffECFDFC),
                                          side: const BorderSide(
                                              width: 1, color: Colors.grey),
                                          selected:
                                          controller.selectedAvailableFilter.value == "Off",
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)),
                                          onSelected: (isSelected) {
                                            controller.selectedAvailableFilter.value = isSelected ?"Off" : null;
                                          },
                                        );}),
                                      ],
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
                                      labelText: "Min Item Price",
                                      hint: "Enter Min Order Value",
                                      controller:controller.filterMinItemPrice,
                                      inputType: TextInputType.number,
                                    ),
                                    EditText(
                                      labelFontWeight: FontWeight.w600,
                                      labelText: "Maximum Item Price*",
                                      hint: "Enter Max Discount",
                                      controller: controller.filterMaxItemPrice,
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
                                      controller.clearFilter();
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
                                      controller.applyFilters();
                                      // controller.filterOrdersByStatus(label: controller.selectedFilter.value,isFilterButton: true);
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
