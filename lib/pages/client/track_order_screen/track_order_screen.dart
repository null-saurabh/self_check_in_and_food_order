import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/order_filter_alert.dart';
import 'package:wandercrew/pages/admin/orders_admin/widgets/single_order.dart';
import 'package:wandercrew/pages/client/track_order_screen/track_order_controller.dart';
import 'package:wandercrew/pages/client/track_order_screen/widgets/track_item_widget.dart';
import 'package:wandercrew/service/razorpay_web.dart';
import 'package:wandercrew/widgets/edit_text.dart';
import 'package:wandercrew/widgets/elevated_container.dart';
import '../../../utils/routes.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/widget_support.dart';


class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackOrderController>(
      init: TrackOrderController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Color(0xffFFFEF9),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 46, bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              if (Get.previousRoute.isNotEmpty) {
                                Get.back(); // Go back if there's a previous route
                              } else {
                                Get.offNamed(Routes
                                    .adminHome); // Navigate to a specific route if there's no back route
                              }
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Track Your',
                                style: AppWidget.black24Text600Style(color: Color(0xffE7C64E))
                                    .copyWith(height: 1),
                              ),
                              Text(
                                'Order',
                                style: AppWidget.black24Text600Style(
                                    )
                                    .copyWith(height: 1),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              // SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedContainer(
                    child: Form(
                      key: controller.formKey,
                      child: EditText(
                        labelText: "Phone Number",
                        hint: "Enter Number to Search Order",
                        hintFontWeight: FontWeight.w600,
                        labelFontWeight: FontWeight.w600,
                        controller: controller.trackNumberController,
                        inputType: TextInputType.number,
                        onValidate: Validators.validatePhoneNumber,
                        suffix: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: AppElevatedButton(
                            borderRadius: 12,
                            onPressed: (){
                              controller.trackOrder();
                            },
                            title: "Track",
                            titleTextColor: Colors.white,
                          ),
                        ),
                      ),
                    )
                ),
              ),

              Obx(() {
                if (controller.trackOrderList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 16, bottom: 16),
                      itemCount: controller.trackOrderList.length,
                      itemBuilder: (context, index) {
                        final data = controller.trackOrderList
                            .elementAt(index);
                        return TrackItemWidget(
                          orderData: data
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
              SizedBox(height: 20,)
            ],
          ),
        );
      },
    );
  }
}
