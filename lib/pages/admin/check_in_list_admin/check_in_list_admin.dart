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
          backgroundColor: const Color(0xffFFFEF9),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 46, bottom: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Get.back(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Self',
                                style: AppWidget.black24Text600Style(
                                    color: Color(0xffE7C64E))
                                    .copyWith(height: 1),
                              ),
                              Text(
                                'Checking',
                                style: AppWidget.black24Text600Style(
                                )
                                    .copyWith(height: 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 12),
                        child: SizedBox(
                          height:40,
                          child: TextField(
                            onChanged: (value) => controller
                                .filterCheckInList(value), // Call the search function
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: "Search by item name",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xffEDCC23)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xffEDCC23)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xffEDCC23)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),




              controller.checkInList.isEmpty
                  ? Expanded(child: const Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 16),
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
