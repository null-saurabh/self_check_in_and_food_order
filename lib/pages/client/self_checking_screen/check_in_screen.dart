import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import 'package:wandercrew/pages/client/self_checking_screen/widgets/form_container.dart';
import 'package:wandercrew/pages/client/self_checking_screen/widgets/gradient_texture.dart';
import '../../../widgets/widget_support.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
        init: CheckInController(),
        builder: (checkInController) {
          return Scaffold(
            backgroundColor: const Color(0xffECFDFC),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  // The gradient image at the bottom right corner
                  // Using the helper function to add gradient textures
                  const CheckInGradientTexture(
                    top: 48,
                    right: -33,
                    assetPath: 'assets/textures/check_in_texture_1.png',
                  ),
                  const CheckInGradientTexture(
                    top: 112,
                    left: -29,
                    assetPath: 'assets/textures/check_in_texture_2.png',
                  ),
                  const CheckInGradientTexture(
                    bottom: 60,
                    left: -32,
                    assetPath: 'assets/textures/check_in_texture_3.png',
                  ),
                  const CheckInGradientTexture(
                    bottom: 60,
                    right: -28,
                    assetPath: 'assets/textures/check_in_texture_4.png',
                  ),

                  Positioned(
                    top: 32,
                    left: 16,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white),
                        child: IconButton(
                            onPressed: () {
                              if (checkInController.currentPage.value > 0) {
                                checkInController.previousPage();
                              } else {
                                Get.back();
                              }
                            },
                            icon: const Icon(Icons.keyboard_backspace_rounded))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 8, left: 8.0, top: 160, bottom: 80),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // White container with form and button
                          const CheckInFormContainer(),

                          // Girl's image positioned at the top left of the container
                          Positioned(
                            top: -124,
                            right: 0,
                            child: Image.asset(
                              'assets/icons/receptionist.png', // Replace with your image asset path
                              width: 124,
                              height: 124,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Speech bubble container next to the girl image
                          Positioned(
                            top: -76,
                            right: 124,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: 145,
                              // height: 52,
                              decoration: const BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/textures/receptionist_text_texture.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child:
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: checkInController.receptionistText.value.substring(0, 4), // "Hi, "
                                        style: AppWidget.white12BoldTextStyle(), // Regular style
                                      ),
                                      TextSpan(
                                        text: checkInController.receptionistText.value.substring(4, 11), // "Please"
                                        style: AppWidget.white12LightTextStyle(), // Different style
                                      ),
                                      TextSpan(
                                        text: checkInController.receptionistText.value.substring(11), // " Enter your details!"
                                        style: AppWidget.white12BoldTextStyle(), // Regular style
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
