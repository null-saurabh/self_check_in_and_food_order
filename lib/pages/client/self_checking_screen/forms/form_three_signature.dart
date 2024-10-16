import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';

import '../../../../widgets/edit_text.dart';
import '../../../../widgets/widget_support.dart';

class CheckInFormThreeSignature extends StatelessWidget {
  const CheckInFormThreeSignature({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
      init: CheckInController(),
      builder: (selfCheckingController) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Form(
            key: selfCheckingController.formKeyPage3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditText(
                  labelText: "Arriving From*",
                  hint: "Enter Place",
                  controller: selfCheckingController.arrivingFromController,
                  onValidate: Validators.requiredField,
                ),
                EditText(
                  labelText: "Going To*",
                  hint: "Enter Place",
                  controller: selfCheckingController.goingToController,
                  onValidate: Validators.requiredField,
                ),


                Text("Signature*",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                SizedBox(height: 8,),
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
                            // dynamicPressureSupported: true,
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


                const SizedBox(height: 16),


                FormField<String>(validator: (value) {
                  if (selfCheckingController.propertyTermsAccepted.value ==
                      false) {
                    return "You must accept property's terms and conditions";
                  }
                  return null;
                }, builder: (formState) {
                  return Obx(() {
                    return CheckboxListTile(
                        title: const Text(
                            "I agree to the property terms & conditions"),
                        value:
                            selfCheckingController.propertyTermsAccepted.value,
                        onChanged: (value) {
                          selfCheckingController.propertyTermsAccepted.value =
                              value!;
                        },
                        subtitle: formState.hasError
                            ? Text(
                                formState.errorText ?? '',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 211, 63, 63),
                                  fontSize: 12,
                                ),
                              )
                            : null // If accepted, return an empty widget (SizedBox.shrink)

                        );
                  });
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
