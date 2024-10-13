import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/elevated_container.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import 'dart:html' as html;

import '../../../models/user_model.dart';

class ReceptionController extends GetxController {
  var adminUsers = <AdminUserModel>[].obs; // Observable list of admin users
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    fetchAdminUsers();
    super.onInit();
  }

  // Fetch admin users from Firestore
  void fetchAdminUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('AdminAccount')
          .where("isOnline", isEqualTo: true)
          .get();

      List<AdminUserModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AdminUserModel.fromMap(
            data); // Using fromMap factory constructor
      }).toList();
      adminUsers.assignAll(newList);
      print(adminUsers.length);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch admin users: $e');
    }
  }

  void makePhoneCall(String number) {
    String phoneNumber = '$number';
    html.window.open('tel:$phoneNumber', '_self');
  }

  void showAdminContacts() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Customize the radius here
          ),
          backgroundColor: Color(0xffFFFEF9),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.68),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20, right: 20.0, left: 20),
                  child: Text(
                    "WanderCrew Team",
                    style: AppWidget.black20Text600Style(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: scrollController,
                        padding: const EdgeInsets.only(
                            bottom: 20, right: 20.0, left: 20),
                        // controller: controller2,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: adminUsers.length,
                        itemBuilder: (context, index) {
                          var adminUser = adminUsers[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  makePhoneCall(adminUser.number);
                                },
                                child: ElevatedContainer(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(

                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            adminUser.role,
                                            style: AppWidget
                                                .black16Text600Style(),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Icon(
                                            Icons.call,
                                            color: Colors.green,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text("Name: "),
                                          Text(adminUser.name),
                                        ],
                                      ),
                                      Row(

                                        children: [
                                          Text("Number: "),
                                          Text(adminUser.number)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(child: AppElevatedButton(onPressed: (){Get.back();},title: "Close", ))
                ,SizedBox(
                  height: 12,
                ),],
            ),
          ),
        );
      },
    );
  }
}
