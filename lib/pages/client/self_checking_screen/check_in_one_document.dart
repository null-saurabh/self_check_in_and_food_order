import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';

import '../../../widgets/widget_support.dart';

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
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country Dropdown with dynamic list
                Column(
                  children: [
                    Text("Document Issue Country",style: AppWidget.bold16TextStyle(),),
                    SizedBox(height: 8,),
                    Obx(() {
                      return DropdownButtonFormField<Map<String, String>>(
                        value: selfCheckingController.documentIssueCountry.value,
                        items: selfCheckingController.countries.map((country) {
                          return DropdownMenuItem(
                              value: country, child: Text(country['name']!));
                        }).toList(),
                        onChanged: (value) => selfCheckingController
                            .documentIssueCountry.value = value!,
                        decoration: InputDecoration(
                            hintText: "-------------",
                          hintStyle: AppWidget.opaque16TextStyle(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select the document issue country'
                            : null,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // Document Type Dropdown
                DropdownButtonFormField<String>(
                  value: selfCheckingController.documentType.value,
                  items: ['Aadhaar', 'Driver License', 'Voter ID', 'Passport']
                      .map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) =>
                      selfCheckingController.documentType.value = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder( // Use OutlineInputBorder for rounded corners
                      borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2), // Border color
                        width: 1, // Border width
                      ),),
                    hintText: "-------------",
                    hintStyle: AppWidget.opaque16TextStyle(),                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a document type'
                      : null,
                ),
                const SizedBox(height: 16),

                // Upload Front Document
                const Text("Upload Front Document",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => selfCheckingController.pickDocument(true),
                  child: const Text("Upload Front Document"),
                ),
                Obx(() {
                  return selfCheckingController.frontDocument.value == null
                      ? const Text("No file selected")
                      : Text(
                          "Front document: ${selfCheckingController.frontDocumentName.value}");
                }),
                const SizedBox(height: 16),

                // Upload Back Document
                const Text("Upload Back Document",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => selfCheckingController.pickDocument(false),
                  child: const Text("Upload Back Document"),
                ),
                Obx(() {
                  return selfCheckingController.backDocument.value == null
                      ? const Text("No file selected")
                      : Text(
                          "Back document: ${selfCheckingController.backDocumentName.value}");
                }),
                const SizedBox(height: 16),

                // Terms and Conditions Checkbox
                CheckboxListTile(
                  title: const Text("I agree to the terms & conditions"),
                  value: selfCheckingController.termsAccepted.value,
                  onChanged: (value) {
                    selfCheckingController.termsAccepted.value = value!;
                    selfCheckingController.update();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: selfCheckingController.termsAccepted.value
                      ? const SizedBox
                          .shrink() // If accepted, return an empty widget (SizedBox.shrink)
                      : const Text(
                          "You must accept the terms and conditions",
                          style: TextStyle(color: Colors.red),
                        ),
                ),

                // const SizedBox(height: 16),
                //
                // // Next Button
                // ElevatedButton(
                //   onPressed: () {
                //     if (selfCheckingController.formKeyPage1.currentState!.validate() &&
                //         selfCheckingController.termsAccepted.value) {
                //       Get.to(() => const CheckInFormTwoPersonal());
                //     } else {
                //       Get.snackbar("Error", "Please complete all required fields.");
                //     }
                //   },
                //   child: const Text("Next"),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
