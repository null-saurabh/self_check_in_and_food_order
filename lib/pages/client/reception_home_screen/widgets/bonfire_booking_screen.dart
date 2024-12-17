import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/edit_text.dart';
import '../../../../widgets/widget_support.dart';
import '../reception_controller.dart';
import 'movie_night_banner.dart';

class BonfireBookingScreen extends StatelessWidget {
  const BonfireBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceptionController>(
      init: ReceptionController(),
      builder: (receptionController) {
        return Scaffold(
          backgroundColor: Colors.white, // Soft background
          body: SingleChildScrollView(
            child: Form(
              key: receptionController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const MovieNightBanner(),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F1FE), // HEX: #f0f1fe
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Light shadow
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Book Your Bonfire",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          // Bonfire Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              "assets/images/bonfire1.png", // Replace with your bonfire image URL
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(height: 16),

                          EditText(
                            labelText: "Your Name",
                            hint: "Enter Full Name",
                            controller: receptionController.name,
                            onValidate: Validators.requiredField,
                          ),

                          EditText(
                            labelText: "Contact",
                            hint: "Enter Contact Number",
                            inputType: TextInputType.number,
                            controller: receptionController.number,
                            onValidate: (p0) {
                              return Validators.validatePhoneNumber(p0);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Preferred Time Section
                          const Text(
                            "Preferred Time",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Obx((){ return Row(
                            mainAxisAlignment: MainAxisAlignment.start
                            ,
                            children: ["6:30", "7:30", "8:30"].map((time) {
                              return Row(
                                children: [
                                  ChoiceChip(
                                    label: Text(
                                      time,
                                      style: TextStyle(
                                        color: receptionController.selectedTime.value == time ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    selected: receptionController.selectedTime.value == time,
                                    selectedColor: Colors.deepPurple,
                                    backgroundColor: Colors.white,
                                    onSelected: (isSelected) {
                                      if (isSelected) {
                                          receptionController.selectedTime.value = time;
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8,)
                                ],
                              );
                            }).toList(),
                          );}),
                          const SizedBox(height: 20),

                          // Total Section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white, // White background
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.deepPurple, // Matching purple border
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2), // Soft shadow
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2), // Shadow offset
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "₹ 1000", // Display total amount
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple, // Highlighted in purple
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Book Now Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (receptionController.formKey.currentState!
                                    .validate()) {
                                  receptionController.bookBonfire(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Book Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Title Section

                  const SizedBox(height: 30),
                  // Movie Night Banner Section
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
