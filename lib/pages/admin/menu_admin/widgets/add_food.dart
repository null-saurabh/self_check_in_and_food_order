import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/widget_support.dart';

import '../../../../models/menu_item_model.dart';
import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/elevated_container.dart';
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
        return Scaffold(
          backgroundColor: const Color(0xffFFFEF9),
          body: Column(
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
                          onPressed: () => Get.back(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Manage',
                              style: AppWidget.black24Text600Style(
                                  color: Color(0xffE7C64E))
                                  .copyWith(height: 1),
                            ),
                            Text(
                              'Menu',
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
                              labelText: "Item Name*",
                              hint: "Enter Item Name",
                              controller: controller.nameController,
                              onValidate: Validators.requiredField,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Item ID*",
                              hint: "Enter Item ID",
                              controller: controller.idController,
                              onValidate: Validators.validateInt,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: Obx(() {
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
                                labelText: "Category*",
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
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Price*",
                              hint: "Enter Item Price",
                              controller: controller.priceController,
                              onValidate: Validators.validateInt,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Description*",
                              hint: "Enter Description",
                              controller: controller.descriptionController,
                              onValidate: Validators.requiredField,
                              maxLine: 6,
                              height: 100,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: Column(
                              children: [
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
                          const SizedBox(height: 28.0),

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

