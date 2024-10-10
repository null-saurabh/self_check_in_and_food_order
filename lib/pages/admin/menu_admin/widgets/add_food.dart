import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/widget_support.dart';

import '../../../../models/menu_item_model.dart';
import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/edit_text.dart';
import '../../../client/self_checking_screen/widgets/upload_document_widget.dart';
import 'add_food_item_controller.dart';

class AddFoodItem extends StatelessWidget {
  final bool isEdit;
  final MenuItemModel? item;
  const AddFoodItem({super.key, this.isEdit = false, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFoodItemController>(
      init: AddFoodItemController(item: item),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: Get.height * 0.84, // Set height to 75% of screen height
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text("Add Food Item",
                      style: AppWidget.heading3BoldTextStyle()),
                ),
                const SizedBox(height: 20.0),
                // First container with mandatory fields
                ElevatedContainer(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        EditText(
                          labelText: "Item Name*",
                          hint: "Enter Item Name",
                          controller: controller.nameController,
                          onValidate: Validators.requiredField,
                        ),
                        EditText(
                          labelText: "Item ID*",
                          hint: "Enter Item ID",
                          controller: controller.idController,
                          onValidate: Validators.validateInt,
                          inputType: TextInputType.number,
                        ),
                        Obx(() {
                          return AppDropDown(
                            items: controller.categories.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: const TextStyle(
                                        fontSize: 18.0, color: Colors.black)),
                              );
                            }).toList(),
                            value: controller.selectedCategory.value,
                            onChange: (value) =>
                                controller.selectedCategory.value = value,
                            hintText: "Select Category",
                            labelText: "Category",
                            showLabel: true,
                            height: 40,
                            iconColor: Colors.grey,
                            showSearch: true,
                            searchCtrl: TextEditingController(),
                            searchMatchFn: (item, searchValue) {
                              searchValue = searchValue.toLowerCase();
                              return item.value
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue);
                            },
                            onValidate: Validators.requiredField,
                          );
                        }),
                        SizedBox(
                          height: 16,
                        ),
                        EditText(
                          labelText: "Price*",
                          hint: "Enter Item Price",
                          controller: controller.priceController,
                          onValidate: Validators.validateInt,
                          inputType: TextInputType.number,
                        ),
                        EditText(
                          labelText: "Description*",
                          hint: "Enter Description",
                          controller: controller.descriptionController,
                          onValidate: Validators.requiredField,
                          maxLine: 6,
                          height: 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Is Veg"),
                            Obx(() => Switch(
                                  value: controller.isVeg.value,
                                  activeColor: Colors.white,
                                  activeTrackColor: Color(0xff2563EB),
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.white,
                                  onChanged: (bool value) {
                                    controller.isVeg.value = value;
                                  },
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Is Available"),
                            Obx(() => Switch(
                                  value: controller.isAvailable.value,
                                  activeColor: Colors.white,
                                  activeTrackColor: Color(0xff2563EB),
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.white,
                                  onChanged: (bool value) {
                                    controller.isAvailable.value = value;
                                  },
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Show Image"),
                            Obx(() => Switch(
                                  value: controller.showImage.value,
                                  activeColor: Colors.white,
                                  activeTrackColor: Color(0xff2563EB),
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.white,
                                  onChanged: (bool value) {
                                    controller.showImage.value = value;
                                  },
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Is Featured"),
                            Obx(() => Switch(
                                  value: controller.isFeatured.value,
                                  activeColor: Colors.white,
                                  activeTrackColor: Color(0xff2563EB),
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.white,
                                  onChanged: (bool value) {
                                    controller.isFeatured.value = value;
                                  },
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Second container with optional fields
                ElevatedContainer(
                  child: Column(
                    children: [
                      Obx(() {
                        return UploadDocumentWidget(
                          title: "Item Image",
                          onTap: () => controller.pickImage(),
                          fileName: controller.itemImageName.value,
                          isDocumentInvalid:
                              controller.isItemImageInvalid.value,
                        );
                      }),
                      const SizedBox(height: 16),
                      EditText(
                        labelText: "Offer Price",
                        hint: "Enter Offer Price",
                        controller: controller.discountPriceController,
                        inputType: TextInputType.number,
                      ),
                      EditText(
                        labelText: "Stock Count",
                        hint: "Enter Stock Count",
                        controller: controller.stockCountController,
                        inputType: TextInputType.number,
                      ),
                      EditText(
                        labelText: "Item Tags",
                        hint: "Enter Item Tags (comma separated)",
                        controller: controller.tagsController,
                      ),
                      EditText(
                        labelText: "Notes",
                        hint: "Enter Notes",
                        controller: controller.notesController,
                      ),
                      EditText(
                        labelText: "Ingredients",
                        hint: "Enter Ingredients (comma separated)",
                        controller: controller.ingredientsController,
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
                        Get.back(); // Cancel action
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
                      onPressed: controller.uploadItem,
                      backgroundColor: Colors.black,
                      child: Text(
                        isEdit ? "Save" : "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ElevatedContainer extends StatelessWidget {
  final Widget child;

  const ElevatedContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
