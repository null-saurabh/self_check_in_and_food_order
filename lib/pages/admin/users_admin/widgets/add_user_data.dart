import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/user_model.dart';
import 'package:wandercrew/pages/admin/menu_admin/widgets/add_food.dart';

import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/widget_support.dart';
import '../../../client/self_checking_screen/widgets/upload_document_widget.dart';
import 'add_user_controller.dart';

class AddNewUserAdmin extends StatelessWidget {
  final bool isEdit;
  final AdminUserModel? data;
  const AddNewUserAdmin({super.key, this.isEdit = false, this.data});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewUserAdminController>(
      init: AddNewUserAdminController(data: data),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: Get.height * 0.84, // Set height to 75% of screen height
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text("Add New User",
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
                          labelText: "Name*",
                          hint: "Enter item name",
                          controller: controller.nameController,
                          onValidate: Validators.requiredField,
                        ),
                        EditText(
                          labelText: "Username*",
                          hint: "Enter unique username",
                          controller: controller.userNameController,
                          onValidate: Validators.requiredField,
                        ),
                        EditText(
                          labelText: "Password*",
                          hint: "Enter Password",
                          controller: controller.passwordController,
                          onValidate: Validators.requiredField,
                        ),
                        EditText(
                          labelText: "Contact Number*",
                          hint: "Enter number",
                          controller: controller.contact,
                          onValidate: Validators.validatePhoneNumber,
                        ),
                        EditText(
                          labelText: "Role*",
                          hint: "Enter role",
                          controller: controller.roleController,
                          onValidate: Validators.requiredField,
                        ),
                        EditText(
                          labelText: "Address*",
                          hint: "Enter address",
                          controller: controller.address,
                          onValidate: Validators.requiredField,
                        ),
                        Obx(() {
                          return AppDropDown(
                            items: [
                              'Admin',
                            ].map((type) {
                              return DropdownMenuItem(
                                  value: type, child: Text(type));
                            }).toList(),
                            value: controller.selectedPermission.value,
                            onChange: (value) =>
                                controller.selectedPermission.value = value,
                            hintText: "Select Permission",
                            labelText: "Permission",
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
                  
                        AppDropDown(
                          items: [
                            'Aadhaar Card',
                            "Driving License",
                            'Voter ID',
                            'Passport'
                          ].map((type) {
                            return DropdownMenuItem(
                                value: type, child: Text(type));
                          }).toList(),
                          onChange: (value) {
                            controller.documentType.value = value;
                            controller.update();
                          },
                          value: controller.documentType.value,
                          labelText: "Document Type",
                          showLabel: true,
                          height: 40,
                          iconColor: Colors.grey,
                          onValidate: Validators.requiredField,
                        ),
                  
                        // Document Type Dropdown
                        const SizedBox(height: 16),
                  
                        // Upload Front Document
                        Obx(() {
                          return UploadDocumentWidget(
                            title: "Front Side of Document\n(Showing ID No.)",
                            onTap: () => controller.pickDocument(true),
                            fileName: controller.frontDocumentName.value,
                            isDocumentInvalid:
                                controller.isFrontDocumentInvalid.value,
                          );
                        }),
                        const SizedBox(height: 16),
                  
                        if (controller.documentType.value != 'Passport') ...[
                          // Upload Back Document
                          Obx(() {
                            return UploadDocumentWidget(
                              title: "Back Side of Document",
                              onTap: () => controller.pickDocument(false),
                              fileName: controller.backDocumentName.value,
                              isDocumentInvalid:
                                  controller.isBackDocumentInvalid.value,
                            );
                          }),
                          const SizedBox(height: 16),
                        ]
                      ],
                    ),
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
                      onPressed: () {
                        controller.submitData();
                      },
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
