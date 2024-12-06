import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import 'package:wandercrew/pages/client/self_checking_screen/widgets/upload_document_widget.dart';
import 'package:wandercrew/utils/routes.dart';
import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/app_elevated_button.dart';
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
                  items: ['Aadhaar Card', "Driving License", 'Voter ID', 'Passport']
                      .map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChange: (value) {
                    selfCheckingController.documentType.value = value;

                  },
                  value: selfCheckingController.documentType.value,
                  labelText: "Document Type",
                  hintText: 'Select Document Type',
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

                  if(selfCheckingController.documentType.value != 'Passport') {
                    return Column(
                    children: [
                      UploadDocumentWidget(
                        title: "Back Side of Document",
                        onTap: () => selfCheckingController.pickDocument(false),
                        fileName: selfCheckingController.backDocumentName.value,
                        isDocumentInvalid:
                            selfCheckingController.isBackDocumentInvalid.value,
                      ),
                      const SizedBox(height: 16),

                    ],


                  );
                  } else{
                  return const SizedBox.shrink();
                  }



                }),
                const SizedBox(height: 16),

                FormField<String>(validator: (value) {
                  if (selfCheckingController.signatureController.isEmpty) {
                    // print("signature verification 1");
                    return "Signature Required";
                  }
                  // print("signature verification 2");
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Signature(
                            controller: selfCheckingController.signatureController,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 4,),
                      // Buttons for undo and reset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Undo Button
                          AppElevatedButton(
                            onPressed: () {
                              if (selfCheckingController.signatureController.isNotEmpty) {
                                selfCheckingController.signatureController.undo();
                              }
                            },
                            title: "Undo",
                            borderRadius: 4,
                            titleTextColor: Colors.white,
                            height: 28,
                            backgroundColor: Color(0xff43B8F3),
                          ),

                          Text("Sign Above",style: AppWidget.black12Text500Style(),),
                          // Reset Button
                          AppElevatedButton(
                            onPressed: () {
                              selfCheckingController.signatureController.clear();
                            },
                            title: "Clear",
                            borderRadius: 4,
                            titleTextColor: Colors.black,
                            height: 28,
                            backgroundColor: Color(0xffFFDE1A),
                          )

                        ],
                      ),


                      if (formState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            formState.errorText ?? '',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 211, 63, 63),
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                // Terms and Conditions Checkbox
                Obx(() {
                  return Column(
                    children: [
                      CheckboxListTile(
                          title: GestureDetector(
                            onTap: () {
                              // Navigate to Terms and Conditions page when the text is tapped
                              context.go(Routes.termAndCondition);

                            },
                            child: const Text(
                              "I agree to the terms & conditions",
                              style: TextStyle(
                                decoration: TextDecoration.underline, // Optional: underline to indicate it's clickable
                                color: Colors.blue,
                              ),
                            ),
                          ),
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
