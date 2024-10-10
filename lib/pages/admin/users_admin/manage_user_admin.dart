import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/users_admin/manage_user_controller.dart';
import 'package:wandercrew/pages/admin/users_admin/widgets/user_data_item.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';

import '../../../widgets/widget_support.dart';

class ManageUserAdmin extends StatelessWidget {
  const ManageUserAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageUserAdminController>(
      init: ManageUserAdminController(),
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
                                  'Manage',
                                  style: AppWidget.black24Text600Style(
                                      color: Color(0xffE7C64E))
                                      .copyWith(height: 1),
                                ),
                                Text(
                                  'User',
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
                                    // onChanged: (value) => controller
                                    //     .filterMenuItems(value), // Call the search function
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "Search",
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
                              SizedBox(width: 4,),
                              AppElevatedButton(
                                showBorder: true,
                                backgroundColor: Colors.transparent,
                                borderColor: Color(0xffEDCC23),
                                borderWidth: 1,
                                titleTextColor: Colors.black,
                                title: "Add User",
                                onPressed: (){},
                              )
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
              ),




              controller.userDataList.isEmpty
                  ? Expanded(child: const Center(child: CircularProgressIndicator()))
                  : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 8, bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: Colors.black.withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0.1,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Administrator Access",style: AppWidget.black16Text600Style(),),
                          SizedBox(height: 8,),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.userDataList.length,
                              itemBuilder: (context, index) {
                                // print(controller.groupedCheckIns.length);
                                final data = controller.userDataList
                                    .elementAt(index);
                                return UserDataItemAdmin(userData: data,);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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