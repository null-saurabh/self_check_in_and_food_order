import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/widgets/check_in_date_section.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import 'check_in_list_controller.dart';

class CheckInListAdmin extends StatelessWidget {
  const CheckInListAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInListController>(
      init: CheckInListController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xffF4F5FA),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                height: 96,
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.s,
                  children: [
                    Positioned(
                      left: 0,
                      top: 28,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Self Check-In List',
                        style: AppWidget.heading3BoldTextStyle(),
                      ),
                    ),
                    // const SizedBox()
                  ],
                ),
              ),
              controller.checkInList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: controller.groupedCheckIns.length,
                          itemBuilder: (context, index) {
                            // print(controller.groupedCheckIns.length);
                            final date = controller.groupedCheckIns.keys
                                .elementAt(index);
                            final checkInAtDate =
                                controller.groupedCheckIns[date]!;
                            return CheckInDateSection(
                              date: date,
                              checkInAtDate: checkInAtDate,
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
