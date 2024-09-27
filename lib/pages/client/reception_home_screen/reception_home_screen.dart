import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/reception_home_screen/widgets/home_screen_menu_widget.dart';

import '../../../widgets/widget_support.dart';
import '../menu_screen/menu_screen_controller.dart';

class ReceptionHomeScreen extends StatelessWidget {
  const ReceptionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder: (menuScreenController) {
          return Scaffold(
            backgroundColor: const Color(0xfffdfded),
            body: Stack(
              children: [
                // The gradient image at the bottom right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.4, // Adjust opacity as needed
                    child: Image.asset(
                      'assets/icons/reception_textures.png', // Your gradient texture image path
                      width: 456, // Adjust size of the gradient
                      height: 560,
                      fit: BoxFit.cover, // Ensure the image fits well
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Wander Crew",style: AppWidget.headingBoldTextStyle()),
                      Text("Your Journey, Our Passion.",style: AppWidget.subHeadingTextStyle()),
                      const SizedBox(height: 48,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        ReceptionHomeGridItem(
                        icon: "assets/icons/check_in.png",
                        label: "Check In",
                        onTap: () {
                          // Add action for check-in
                          Get.toNamed('/reception/checkIn');

                        },
                      ),
                          const SizedBox(width: 24,),

                          ReceptionHomeGridItem(
                            icon: "assets/icons/burger.png",
                            label: "Order Food",
                            onTap: () {
                              // Add action for order food
                              Get.toNamed('/reception/menu');

                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 24,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          ReceptionHomeGridItem(
                            icon: "assets/icons/feedback.png",
                            label: "Feedback",
                            onTap: () {
                              // Add action for feedback
                              // Get.toNamed(page);
                            },
                          ),
                          const SizedBox(width: 24,),

                          ReceptionHomeGridItem(
                            icon: "assets/icons/room_service.png",
                            label: "Room Service",
                            onTap: () {
                              // Add action for room service
                              // Get.toNamed(page);

                            },
                          )
                        ],
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
