import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/client/track_order_screen/track_order_controller.dart';
import 'package:wandercrew/pages/client/track_order_screen/widgets/track_item_widget.dart';
import 'package:wandercrew/widgets/edit_text.dart';
import 'package:wandercrew/widgets/elevated_container.dart';
import '../../../widgets/app_elevated_button.dart';
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
                          GoRouter.of(context).canPop()
                         ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                                context.pop(); // Go back if there's a previous route

                            },
                          ):SizedBox.shrink(),
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
                              controller.trackOrder(context);
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
