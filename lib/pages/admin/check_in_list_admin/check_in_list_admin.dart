import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/widgets/check_in_date_section.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/widgets/filter_check_in_list.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../../../widgets/app_elevated_button.dart';
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
                          GoRouter.of(context).canPop()
                              ?IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                                context.pop(); // Go back if there's a previous route

                            },
                          ):SizedBox.shrink(),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height:40,
                                child: TextField(
                                  onChanged: (value) => controller
                                      .searchFilterCheckInList(value), // Call the search function
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
                            SizedBox(width: 8,),
                            Stack(
                              children: [
                                Obx(() {

                                  // Only show the circle if there are active filters
                                  if (controller.activeFilterCount.value > 0) {
                                    return Positioned(
                                      right: 4,  // Adjust this to position it properly
                                      top: -2,    // Adjust this to position it properly
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          controller.activeFilterCount.value.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox.shrink(); // Return empty widget if no filters are active
                                  }
                                }),
                                AppElevatedButton(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  width: 40,
                                  showBorder: true,
                                  backgroundColor: Colors.transparent,
                                  borderColor: Color(0xffEDCC23),
                                  borderWidth: 1,
                                  titleTextColor: Colors.black,
                                  child: Icon(Icons.filter_alt, color: Colors.black, size: 22),

                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FilterCheckInList();
                                        }
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ),



              Obx(() {
                if (controller.checkInList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 8, bottom: 16),
                      itemCount: controller.groupedCheckIns.length,
                      itemBuilder: (context, index) {
                        // print(controller.groupedCheckIns.length);
                        final data = controller.groupedCheckIns.keys
                            .elementAt(index);
                        final checkInAtDate =
                        controller.groupedCheckIns[data]!;
                        return CheckInDateSection(
                          date: data,
                          checkInAtDate: checkInAtDate,
                        );
                      },
                    ),
                  );
                } else if (controller.isLoading.value) {
                  return Expanded(
                      child: const Center(child: CircularProgressIndicator()));
                } else {
                  return Expanded(
                      child: const Center(child: Text("No Guest Data Found.")));
                }
              }),

            ],
          ),
        );
      },
    );
  }
}
