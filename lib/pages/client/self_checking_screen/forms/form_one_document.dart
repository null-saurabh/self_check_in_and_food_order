import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import 'package:wandercrew/pages/client/self_checking_screen/widgets/upload_document_widget.dart';

import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/widget_support.dart';

class CheckInFormOneDocument extends StatelessWidget {
  const CheckInFormOneDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
      init: CheckInController(),
      builder: (selfCheckingController) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Form(
            key: selfCheckingController.formKeyPage1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country Dropdown with dynamic list
                // Obx(() {
                // }),

                AppDropDown(
                  items: selfCheckingController.countries.map((country) {
                    return DropdownMenuItem(
                        value: country['name'], child: Text(country['name']!));
                  }).toList(),
                  onChange: (value) => selfCheckingController
                      .documentIssueCountry.value = value!,
                  value: selfCheckingController.documentIssueCountry.value,
                  hintText: "-------------",
                  labelText: "Document Issue Country",
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

                const SizedBox(height: 16),
                // Obx(() { return

                AppDropDown(
                  items: ['Aadhaar', 'Driver License', 'Voter ID', 'Passport']
                      .map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChange: (value) =>
                  selfCheckingController.documentType.value = value,
                  value: selfCheckingController.documentType.value,
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
                    onTap: () => selfCheckingController.pickDocument(true),
                    fileName: selfCheckingController.frontDocumentName.value,
                    isDocumentInvalid:
                        selfCheckingController.isFrontDocumentInvalid.value,
                  );
                }),
                const SizedBox(height: 16),

                // Upload Back Document
                Obx(() {
                  return UploadDocumentWidget(
                    title: "Back Side of Document",
                    onTap: () => selfCheckingController.pickDocument(false),
                    fileName: selfCheckingController.backDocumentName.value,
                    isDocumentInvalid:
                        selfCheckingController.isBackDocumentInvalid.value,
                  );
                }),
                const SizedBox(height: 16),

                // Terms and Conditions Checkbox
                Obx(() {
                  return Column(
                    children: [
                      CheckboxListTile(
                          title:
                              const Text("I agree to the terms & conditions"),
                          value: selfCheckingController.termsAccepted.value,
                          onChanged: (value) {
                            selfCheckingController.termsAccepted.value = value!;
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          subtitle: selfCheckingController.isTermAccepted.value
                              ? const Text(
                                  "You must accept the terms and conditions",
                                  style: TextStyle(color: Colors.red),
                                )
                              : null // If accepted, return an empty widget (SizedBox.shrink)

                          ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
