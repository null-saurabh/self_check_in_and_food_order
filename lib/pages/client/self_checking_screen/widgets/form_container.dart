import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wandercrew/pages/client/self_checking_screen/widgets/form_button.dart';

import '../check_in_controller.dart';
import '../forms/check_in_one_document.dart';
import '../check_in_three_signature.dart';
import '../check_in_two_personal.dart';

class CheckInFormContainer extends StatelessWidget {
  const CheckInFormContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
        init: CheckInController(),
        builder: (checkInController) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.88,
            // height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  return Stack(
                    children: [
                      // Positioned indicator bar
                      AnimatedPositioned(
                        duration: const Duration(
                            milliseconds: 500), // Animation duration
                        left: checkInController.currentPage.value *
                            (MediaQuery.of(context).size.width *
                                0.85 /
                                3), // Adjust the position
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.85 /
                              3, // Width of the indicator
                          height: 5,
                          color: Colors.black, // Color of the active indicator
                        ),
                      ),
                      // Row for inactive indicators
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                                height: 5,
                                color: Colors
                                    .transparent // Make it transparent to show the active indicator

                                ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                // AnimatedSize(
                //   duration: const Duration(milliseconds: 1000),
                //   child:
                AnimatedSwitcher(
                    duration: const Duration(
                        milliseconds: 500), // Fade animation duration
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: checkInController.currentPage.value == 1
                        ? const CheckInFormOneDocument(key: ValueKey('Page1'))
                        : checkInController.currentPage.value == 0
                            ? const CheckInFormTwoPersonal(
                                key: ValueKey('Page2'))
                            : const CheckInFormThreeSignature(
                                key: ValueKey('Page3'))),
                // ),
                const SizedBox(height: 24),
                Obx(() {
                  return FormButton(
                    onPressed: () {
                      if (checkInController.currentPage.value == 0) {
                        if (checkInController.validateFormPage1() &&
                            checkInController.termsAccepted.value) {
                          checkInController.nextPage();
                        } else {
                          checkInController.receptionistText.value =
                              "Error! Please complete all required fields.";
                        }
                      } else if (checkInController.currentPage.value == 1) {
                        // print("validating form 2");
                        if (checkInController.formKeyPage2.currentState!
                            .validate()) {
                          checkInController.nextPage();
                        } else {
                          checkInController.receptionistText.value =
                              "Ops! Looks like there some issue.";
                        }
                      } else {
                        if (checkInController.formKeyPage3.currentState!
                            .validate()) {
                          checkInController.submitData();
                        } else {
                          checkInController.receptionistText.value =
                              "Sign Please.";
                        }
                      }
                    },
                    name: checkInController.currentPage.value < 2
                        ? "Next"
                        : "Submit",
                  );
                }),
              ],
            ),
          );
        });
  }
}
