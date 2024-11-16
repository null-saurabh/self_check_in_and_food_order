import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/elevated_container.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;


import '../../../models/user_model.dart';
import '../self_checking_screen/check_in_controller.dart';

class ReceptionController extends GetxController {
  var adminUsers = <AdminUserModel>[].obs; // Observable list of admin users
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // fetchCountryCodes(); // Fetch countries from API when controller is initialized
    fetchCountriesFromCheckInController();
    fetchAdminUsers();
    super.onInit();
  }


  void fetchCountriesFromCheckInController() {
    // Find the CheckInController instance and call fetchCountryCodes
    CheckInController checkInController = Get.put(CheckInController());
    checkInController.fetchCountries();

  }



  Future<void> refreshPage() async{
    html.window.location.reload(); // This will reload the entire page
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
      // print(adminUsers.length);
      update();
    } catch (e) {
      debugPrint("Failed to fetch admin users: $e");


    }
  }

  void makePhoneCall(String number) {
    String phoneNumber = '$number';
    html.window.open('tel:$phoneNumber', '_self');
  }

  void showAdminContacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                BorderRadius.circular(12.0), // Customize the radius here
          ),
          backgroundColor: const Color(0xffFFFEF9),
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
                const SizedBox(
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
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          const Icon(
                                            Icons.call,
                                            color: Colors.green,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          const Text("Name: "),
                                          Text(adminUser.name),
                                        ],
                                      ),
                                      Row(

                                        children: [
                                          const Text("Number: "),
                                          Text(adminUser.number)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(child: AppElevatedButton(onPressed: (){context.pop();},title: "Close", ))
                ,const SizedBox(
                  height: 12,
                ),],
            ),
          ),
        );
      },
    );
  }
}
