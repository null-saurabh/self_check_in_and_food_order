import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/widgets/add_voucher.dart';
import 'package:wandercrew/pages/admin/vouchers_admin/widgets/voucher_item.dart';
import 'package:wandercrew/utils/routes.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';

import '../../../widgets/elevated_container.dart';
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
                  child: Column(children: [
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
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          // onChanged: (value) => controller
                          //     .filterMenuItems(value), // Call the search function
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Search by Code/Discount",
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

              controller.voucherList.isEmpty
                  ? Expanded(child: const Center(child: CircularProgressIndicator()))
                  : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 8, bottom: 16),
                  child: ListView.builder(
                    itemCount: controller.voucherList.length,
                    itemBuilder: (context, index) {
                      final data = controller.voucherList
                          .elementAt(index);
                      return VoucherItemAdmin(
                        voucherData: data,
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
