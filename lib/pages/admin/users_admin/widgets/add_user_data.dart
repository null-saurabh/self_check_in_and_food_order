import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/models/user_model.dart';
import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/elevated_container.dart';
import '../../../../widgets/widget_support.dart';
import '../../../client/self_checking_screen/widgets/upload_document_widget.dart';
import '../manage_user_controller.dart';
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
        // print("starting3");
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                          onPressed: () => context.pop(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Manage',
                              style: AppWidget.black24Text600Style(
                                      color: const Color(0xffE7C64E))
                                  .copyWith(height: 1),
                            ),
                            Text(
                              'User',
                              style: AppWidget.black24Text600Style()
                                  .copyWith(height: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    )
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
                              labelText: "Name",
                              hint: "Enter item name",
                              controller: controller.nameController,
                              onValidate: Validators.requiredField,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Username",
                              hint: "Enter unique username",
                              controller: controller.userNameController,
                              onValidate: (value) {
                                // Check if the field is empty
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username is required';
                                }
                                var userController =
                                    Get.find<ManageUserAdminController>();
                                // Check if the username already exists in userDataList
                                if (userController.userDataList.any(
                                    (user) => user.userId == value.trim())) {
                                  return 'Username already taken';
                                }
                                return null; // Return null if validation passes
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Password",
                              hint: "Enter Password",
                              controller: controller.passwordController,
                              onValidate: Validators.requiredField,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Contact Number",
                              hint: "Enter number",
                              controller: controller.contact,
                              onValidate: Validators.validatePhoneNumber,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Role",
                              hint: "Enter role",
                              controller: controller.roleController,
                              onValidate: Validators.requiredField,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedContainer(
                            child: EditText(
                              labelText: "Address",
                              hint: "Enter address",
                              controller: controller.address,
                              onValidate: Validators.requiredField,
                            ),
                          ),
                          const SizedBox(height: 16),

                         Obx(() { return ElevatedContainer(
                            child: AppDropDown(
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
                            ),
                          );}),
                          const SizedBox(height: 16),

                          ElevatedContainer(
                            child: AppDropDown(
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
                              hintText: "Select document type",
                              showLabel: true,
                              height: 40,
                              iconColor: Colors.grey,
                              onValidate: Validators.requiredField,
                            ),
                          ),

                          // Document Type Dropdown
                          const SizedBox(height: 16),

                          // Upload Front Document
                          ElevatedContainer(
                            child: Obx(() {
                              return UploadDocumentWidget(
                                title:
                                    "Front Side of Document\n(Showing ID No.)",
                                onTap: () => controller.pickDocument(context,true),
                                fileName: controller.frontDocumentName.value,
                                isDocumentInvalid:
                                    controller.isFrontDocumentInvalid.value,
                              );
                            }),
                          ),
                          const SizedBox(height: 16),

                          Obx(() {
                            if (controller.documentType.value != 'Passport') {
                              // Upload Back Document
                              return ElevatedContainer(
                                  child: UploadDocumentWidget(
                                title: "Back  Side of Document",
                                onTap: () => controller.pickDocument(context,false),
                                fileName: controller.backDocumentName.value,
                                isDocumentInvalid:
                                    controller.isBackDocumentInvalid.value,
                              ));
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),

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
                              const SizedBox(
                                width: 16,
                              ),
                              AppElevatedButton(
                                onPressed: () {
                                  if (controller.validateForm()) {
                                    controller.submitData(context);
                                  }
                                },
                                backgroundColor: Colors.black,
                                child: Text(
                                  isEdit ? "Save" : "Add",
                                  style: const TextStyle(color: Colors.white),
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
