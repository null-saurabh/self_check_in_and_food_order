import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import 'package:wandercrew/pages/client/self_checking_screen/widgets/upload_document_widget.dart';

import '../../../../widgets/custom_dropdown.dart';

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
                CustomDropdownButton<Map<String, String>>(
                  value: selfCheckingController.documentIssueCountry.value,
                  items: selfCheckingController.countries.map((country) {
                    return DropdownMenuItem(
                        value: country, child: Text(country['name']!));
                  }).toList(),
                  onChanged: (value) => selfCheckingController
                      .documentIssueCountry.value = value!,
                  hintText: "-------------",
                  labelText: "Document Issue Country",
                  onValidate: (p0) {
                    if (p0 == null) {
                      return "*Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownButton(
                  value: selfCheckingController.documentType.value,
                  items: ['Aadhaar', 'Driver License', 'Voter ID', 'Passport']
                      .map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) =>
                      selfCheckingController.documentType.value = value,
                  hintText: "-------------",
                  labelText: "Document Type",
                  onValidate: (p0) {
                    if (p0 == null) {
                      return "*Required";
                    }
                    return null;
                  },
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
