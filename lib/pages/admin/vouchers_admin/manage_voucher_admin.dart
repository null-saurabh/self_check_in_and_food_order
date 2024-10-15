import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/widgets/add_voucher.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/widgets/voucher_filter_alert.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/widgets/voucher_item.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';

import '../../../widgets/elevated_container.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/widget_support.dart';
import 'manage_voucher_controller.dart';

class ManageVoucherAdmin extends StatelessWidget {
  const ManageVoucherAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageVoucherAdminController>(
      init: ManageVoucherAdminController(),
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
                        Get.previousRoute.isNotEmpty
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
                              'Food',
                              style: AppWidget.black24Text600Style(
                                      color: Color(0xffE7C64E))
                                  .copyWith(height: 1),
                            ),
                            Text(
                              'Voucher',
                              style: AppWidget.black24Text600Style()
                                  .copyWith(height: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    onChanged: (value) => controller.searchFilterVoucher(
                                        value), // Call the search function
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "Search by Code, Discount, ....",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon:
                                          Icon(Icons.search, color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Color(0xffEDCC23)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Stack(
                                children: [
                                  Obx(() {
                                    // Only show the circle if there are active filters
                                    if (controller.activeFilterCount.value > 0) {
                                      return Positioned(
                                        right:
                                            4, // Adjust this to position it properly
                                        top:
                                            -2, // Adjust this to position it properly
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            controller.activeFilterCount.value
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox
                                          .shrink(); // Return empty widget if no filters are active
                                    }
                                  }),
                                  AppElevatedButton(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    width: 40,
                                    showBorder: true,
                                    backgroundColor: Colors.transparent,
                                    borderColor: Color(0xffEDCC23),
                                    borderWidth: 1,
                                    titleTextColor: Colors.black,
                                    child: Icon(Icons.filter_alt,
                                        color: Colors.black, size: 22),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return VoucherFilterAlert();
                                          });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                FilterButton(
                                  label: "All",
                                  isSelected:
                                  controller.selectedFilter.value == "All",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        label:"All");
                                  },
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                FilterButton(
                                  label: "Active",
                                  isSelected: controller.selectedFilter.value ==
                                      "Active",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        label: "Active");
                                  },
                                ),
                                SizedBox(
                                  width: 4,
                                ),FilterButton(
                                  label: "Disabled",
                                  isSelected: controller.selectedFilter.value ==
                                      "Disabled",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        label: "Disabled");
                                  },
                                ),

                                SizedBox(
                                  width: 4,
                                ),
                                FilterButton(
                                  label: "Used",
                                  isSelected: controller.selectedFilter.value ==
                                      "Used",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        label:"Used");
                                  },
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                FilterButton(
                                  label: "Expired",
                                  isSelected: controller.selectedFilter.value ==
                                      "Expired",
                                  onTap: () {
                                    controller.filterOrdersByStatus(
                                        label: "Expired");
                                  },
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Voucher',
                        style: AppWidget.black16Text600Style(),
                      ),
                      AppElevatedButton(
                        onPressed: () {
                          Get.bottomSheet(
                            AddVoucherAdmin(),
                            isScrollControlled:
                                true, // Allows the bottom sheet to expand with keyboard
                            backgroundColor: Color(0xffF4F5FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16.0, top: 4, bottom: 4),
                    child: GestureDetector(
                      onTap: (){controller.refreshAndExpireCoupons(context);},
                      child: Icon(Icons.refresh),
                    ),
                  )
                ],
              ),
              Obx(() {
                if (controller.voucherList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 8, bottom: 16),
                      itemCount: controller.voucherList.length,
                      itemBuilder: (context, index) {
                        final data = controller.voucherList.elementAt(index);
                        return VoucherItemAdmin(
                          voucherData: data,
                        );
                      },
                    ),
                  );
                } else if (controller.isLoading.value) {
                  return Expanded(
                      child: const Center(child: CircularProgressIndicator()));
                } else {
                  return Expanded(
                      child: const Center(child: Text("No orders found.")));
                }
              }),
            ],
          ),
        );
      },
    );
  }
}
