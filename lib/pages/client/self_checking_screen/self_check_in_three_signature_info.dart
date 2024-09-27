import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';

class SelfCheckInThreeSignatureInfo extends StatelessWidget {
  const SelfCheckInThreeSignatureInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
      init: CheckInController(),
      builder: (selfCheckingController) {
        return Scaffold(
          appBar: AppBar(title: const Text("Additional Information")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: selfCheckingController.formKeyPage3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: selfCheckingController.arrivingFromController,
                    decoration: const InputDecoration(labelText: "Arriving From"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter where you are arriving from.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: selfCheckingController.goingToController,
                    decoration: const InputDecoration(labelText: "Going To"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter where you are going to.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Signature(
                      controller: selfCheckingController.signatureController,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text("I agree to the property terms & conditions"),
                    value: selfCheckingController.propertyTermsAccepted.value,
                    onChanged: (value) {
                      selfCheckingController.propertyTermsAccepted.value = value!;
                      selfCheckingController.update();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selfCheckingController.formKeyPage3.currentState!.validate() && !selfCheckingController.isSignatureEmpty()) {
                        selfCheckingController.submitData(); // Call to submit data
                      } else {
                        if (selfCheckingController.isSignatureEmpty()) {
                          Get.snackbar("Error", "Please provide your signature.");
                        }
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
