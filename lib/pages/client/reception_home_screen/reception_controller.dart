// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/elevated_container.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import 'dart:html' as html;
// import 'package:http/http.dart' as http;


import '../../../models/user_model.dart';
import '../self_checking_screen/check_in_controller.dart';

class ReceptionController extends GetxController {
  var adminUsers = <AdminUserModel>[].obs; // Observable list of admin users
  ScrollController scrollController = ScrollController();

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController time = TextEditingController();
  RxString selectedTime = "7:30".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  // Future<void> addIndexToMenuItems() async {
  //   try {
  //     print('tring');
  //
  //     final collectionRef = FirebaseFirestore.instance.collection('Menu');
  //     final snapshot = await collectionRef.get();
  //
  //     if (snapshot.docs.isEmpty) {
  //       print('No menu items found.');
  //       return;
  //     }
  //
  //     int index = 1;
  //     WriteBatch batch = FirebaseFirestore.instance.batch();
  //
  //     for (var doc in snapshot.docs) {
  //       // Reference to the document
  //       DocumentReference docRef = collectionRef.doc(doc.id);
  //       print('doing $index');
  //
  //       // Add "itemIndexNumber" field
  //       batch.update(docRef, {'itemIndexNumber': index});
  //       index++;
  //
  //       // Commit batch after 500 updates to avoid size limit
  //       if (index % 500 == 0) {
  //         await batch.commit();
  //         batch = FirebaseFirestore.instance.batch();
  //       }
  //     }
  //
  //     // Commit the remaining batch
  //     await batch.commit();
  //     print('All menu items updated successfully.');
  //   } catch (e) {
  //     print('Error updating menu items: $e');
  //   }
  // }

  Future<void> addAvailableTimesToMenuItems() async {
    try {
      // print('Starting to add availableTimes to menu items.');

      final collectionRef = FirebaseFirestore.instance.collection('Menu_Category');
      final snapshot = await collectionRef.get();

      if (snapshot.docs.isEmpty) {
        // print('No menu items found.');
        return;
      }

      // Define the default available times (using strings in "HH:mm" format)
      List<Map<String, String>> defaultAvailableTimes = [
        {
          'start': '07:30', // 7:30 AM
          'end': '11:00',   // 11:00 AM
        },
        {
          'start': '17:00', // 5:00 PM
          'end': '21:00',   // 9:00 PM
        },
      ];

      WriteBatch batch = FirebaseFirestore.instance.batch();
      int index = 0;

      for (var doc in snapshot.docs) {
        // Reference to the document
        DocumentReference docRef = collectionRef.doc(doc.id);
        // print('Updating availableTimes for item $index');

        // Add "availableTimes" field as the default times
        batch.update(docRef, {'availableTimes': defaultAvailableTimes});
        index++;

        // Commit batch after 500 updates to avoid size limit
        if (index % 500 == 0) {
          await batch.commit();
          batch = FirebaseFirestore.instance.batch();
        }
      }

      // Commit the remaining batch
      await batch.commit();
      // print('All menu items updated with availableTimes successfully.');
    } catch (e) {
      // print('Error updating menu items with availableTimes: $e');
    }
  }



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
    String phoneNumber = number;
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


  Future<void> bookBonfire(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate data for booking
      Map<String, dynamic> bonfireData = {
        "name": name.text,
        "contact": number.text,
        "preferredTime": selectedTime,
        "bookedAt": Timestamp.now(), // Current server time
      };

      // Add booking to the 'Bonfire' collection
      await firestore.collection("Bonfire").add(bonfireData);

      // Dismiss loading dialog
      context.pop();
      context.pop();

      const snackBar = SnackBar(
        content: Text("Success: Bonfire successfully booked!",),
        backgroundColor: Colors.green,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


      // Clear form fields after booking
      name.clear();
      number.clear();
      selectedTime.value = "7:30";
      update(); // Notify GetBuilder to rebuild widgets if necessary
    } catch (e) {
      // Dismiss loading dialog
      Get.back();

      const snackBar = SnackBar(
        content: Text(
            "Failed to book bonfire. Please try again."),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // // Show error Snackbar
      // Get.snackbar(
      //   "Error",
      //   "Failed to book bonfire. Please try again.",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }
  }
}
