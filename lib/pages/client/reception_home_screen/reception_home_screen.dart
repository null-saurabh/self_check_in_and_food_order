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
            backgroundColor: const Color(0xfffdfded),
            body: Stack(
              children: [

                // The gradient image at the bottom right corner
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: Opacity(
                //     opacity: 0.4, // Adjust opacity as needed
                //     child: Image.asset(
                //       'assets/textures/reception_textures.png', // Your gradient texture image path
                //       width: 456, // Adjust size of the gradient
                //       height: 560,
                //       fit: BoxFit.cover, // Ensure the image fits well
                //     ),
                //   ),
                // ),


                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Wander Crew",style: AppWidget.headingBoldTextStyle()),
                          const SizedBox(width: 4,),
                          Text("CREW",style: AppWidget.headingYellowBoldTextStyle()),
                        ],
                      ),

                      Text("Your Journey, Our Passion.",style: AppWidget.subHeadingTextStyle()),
                      const SizedBox(height: 48,),


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
        const SizedBox(height: 12,),
        ReceptionHomeGridItem(
          height: 83,
          isRoomService: true,
          labelIcon: Icon(Icons.call, color: Colors.green,size: 20,),
          label: "Room Service",
          onTap: () {
            controller.makePhoneCall();
          },
        )

      ],
    ),
    const SizedBox(width: 12,),


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
        const SizedBox(height: 12,),

        ReceptionHomeGridItem(
          height: 133,
          iconHeight: 55,
          iconWidth: 55,
          icon: "assets/icons/feedback.png",
          label: "Feedback",
          onTap: () {
          },
        ),


      ],
    ),
  ],
)

                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
