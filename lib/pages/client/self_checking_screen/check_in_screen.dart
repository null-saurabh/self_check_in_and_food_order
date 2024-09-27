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
            backgroundColor: const Color(0xfffdfded),
            body: Stack(
              children: [
                // The gradient image at the bottom right corner
                // Using the helper function to add gradient textures
                const CheckInGradientTexture(
                  alignment: Alignment.topRight,
                  assetPath: 'assets/icons/check_in_texture_1.png',
                ),
                const CheckInGradientTexture(
                  alignment: Alignment.topLeft,
                  assetPath: 'assets/icons/check_in_texture_2.png',
                ),
                const CheckInGradientTexture(
                  alignment: Alignment.bottomLeft,
                  assetPath: 'assets/icons/check_in_texture_3.png',
                ),
                const CheckInGradientTexture(
                  alignment: Alignment.bottomRight,
                  assetPath: 'assets/icons/check_in_texture_4.png',
                ),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
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
                      // White container with form and button
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
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12),bottomLeft: Radius.circular(12)),
                            image: DecorationImage(
                              image: AssetImage("assets/icons/receptionist_text_texture.png"),
                              fit: BoxFit.cover,
                            ),

                          ),
                          child: Center(
                            child: Text(
                              checkInController.receptionistText.value,
                              style: AppWidget.white12TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          );
        });
  }
}

