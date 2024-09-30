import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../../client/reception_home_screen/widgets/home_screen_menu_widget.dart';
import '../orders_admin/admin_order_controller.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminOrderListController>(
      init: AdminOrderListController(),
      builder: (orderController) {
        return Scaffold(
          backgroundColor: const Color(0xffFDFDED),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("WANDER",style: AppWidget.headingBoldTextStyle()),
                    const SizedBox(width: 4,),
                    Text("CREW",style: AppWidget.headingYellowBoldTextStyle()),
                  ],
                ),
                Text("Admin",style: AppWidget.heading2BoldTextStyle()),
                const SizedBox(height: 48,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReceptionHomeGridItem(
                      icon: "assets/icons/check_in.png",
                      label: "Check In List",
                      onTap: () {
                        // Add action for check-in
                        Get.toNamed('/admin/check-in-list');
                      },
                    ),
                    const SizedBox(width: 24,),
                    ReceptionHomeGridItem(
                      icon: "assets/icons/order_list.png",
                      label: "Order List",
                      onTap: () {
                        Get.toNamed("/admin/order-list");
                      },
                    ),

                  ],
                ),
                const SizedBox(height: 24,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    ReceptionHomeGridItem(
                      icon: "assets/icons/burger.png",
                      label: "Manage Menu",
                      onTap: () {
                        // Add action for order food
                        Get.toNamed('/admin/add-menu');
                      },
                    ),
                    const SizedBox(width: 24,),

                    ReceptionHomeGridItem(
                      icon: "assets/icons/room_service.png",
                      label: "Manage Users",
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
        );
      },
    );
  }

}
