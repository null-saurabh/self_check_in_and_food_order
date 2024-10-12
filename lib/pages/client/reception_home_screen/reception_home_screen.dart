import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/reception_home_screen/reception_controller.dart';
import 'package:wandercrew/pages/client/reception_home_screen/widgets/home_screen_menu_widget.dart';

import '../../../widgets/widget_support.dart';

class ReceptionHomeScreen extends StatelessWidget {
  const ReceptionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceptionController>(
        init: ReceptionController(),
        builder: (controller) {
          return Scaffold(
            // backgroundColor: const Color(0xfffdfded),
            body: Container(
              // Apply the gradient background
              decoration: BoxDecoration(

                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF887CC8), // Starting color
                    Color(0xFFA1D5DF), // Middle color
                    Color(0xFFABF8E8), // End color
                  ],
                  stops: [
                    0.2746,  // 27.46%
                    0.7713,  // 77.13%
                    1.2076,  // 120.76% (Note: values above 1 are clipped)
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/textures/reception_noise.png'), // Replace with your image path
                  fit: BoxFit.cover, // To make the image cover the entire container
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("WANDER",
                            style: AppWidget.white32Heading700TextStyle()),
                        const SizedBox(
                          width: 4,
                        ),
                        Text("CREW",
                            style: AppWidget.headingBoldTextStyle()),
                      ],
                    ),
                    Text("Your Journey, Our Passion.",
                        style: AppWidget.white12SubHeadingTextStyle()),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReceptionHomeGridItem(
                              height: 249,
                              iconWidth: 152,
                              iconHeight: 152,
                              isCheckIn: true,
                              icon: "assets/icons/check_in.png",
                              label: "Check In",
                              onTap: () {
                                // Add action for check-in
                                Get.toNamed('/reception/checkIn');
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ReceptionHomeGridItem(
                              height: 83,
                              isRoomService: true,
                              labelIcon: Icon(
                                Icons.call,
                                color: Colors.green,
                                size: 20,
                              ),
                              label: "Room Service",
                              onTap: () {
                                controller.makePhoneCall();
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReceptionHomeGridItem(
                              height: 199,
                              icon: "assets/icons/burger.png",
                              label: "Order Food",
                              onTap: () {
                                // Add action for order food
                                Get.toNamed('/reception/menu');
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ReceptionHomeGridItem(
                              height: 133,
                              iconHeight: 55,
                              iconWidth: 55,
                              icon: "assets/icons/feedback.png",
                              label: "Track Order",
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
