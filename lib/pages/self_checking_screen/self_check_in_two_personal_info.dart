import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/self_checking_screen/self_check_in_controller.dart';
import 'package:wandercrew/pages/self_checking_screen/self_check_in_three_signature_info.dart';

import '../../widgets/edittext.dart';

class SelfCheckInTwoPersonalInfo extends StatelessWidget {
  const SelfCheckInTwoPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelfCheckInController>(
      init: SelfCheckInController(),
      builder: (selfCheckingController) {
        return Scaffold(
          appBar: AppBar(title: const Text("Personal Information")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: selfCheckingController.formKeyPage2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  EditText(
                    label: "Full Name",
                    controller: selfCheckingController.fullName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Full Name is required";
                      }
                      return null;
                    },
                  ),

                  // Email Address
                  EditText(
                    label: "Email Address",
                    keyboardType: TextInputType.emailAddress,
                    controller: selfCheckingController.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),

                  // Contact with Country Code Dropdown
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: selfCheckingController.selectedCountryCode.value,
                            items: selfCheckingController.countryCodes.map((codeData) {
                              return DropdownMenuItem(
                                value: codeData['code'],  // Ensure `code` is treated as a string
                                child: Row(
                                  children: [
                                    Image.network(
                                      codeData['flag'] ?? '',  // Default to empty string if flag is null
                                      width: 24,
                                      height: 24,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.flag);  // Provide a fallback if flag image fails to load
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(codeData['code']!),  // Safely use code as text
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selfCheckingController.selectedCountryCode.value = value!;
                            },
                            decoration: const InputDecoration(
                              labelText: "Country Code",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: EditText(
                            label: "Contact",
                            keyboardType: TextInputType.phone,
                            controller: selfCheckingController.contact,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Contact is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  }),


                  // Age
                  EditText(
                    label: "Age",
                    keyboardType: TextInputType.number,
                    controller: selfCheckingController.age,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Age is required";
                      }
                      return null;
                    },
                  ),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: selfCheckingController.gender.value.isNotEmpty
                        ? selfCheckingController.gender.value
                        : null,
                    items: ["Male", "Female", "Other"].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) => selfCheckingController.gender.value = value!,
                    decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Gender is required";
                      }
                      return null;
                    },
                  ),

                  // Address
                  EditText(
                    label: "Address",
                    controller: selfCheckingController.address,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Address is required";
                      }
                      return null;
                    },
                  ),

                  // City
                  EditText(
                    label: "City",
                    controller: selfCheckingController.city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "City is required";
                      }
                      return null;
                    },
                  ),

                  // Country Dropdown
                  Obx(() {
                    return DropdownButtonFormField<Map<String, String>>(
                      value: selfCheckingController.selectedCountry.value,
                      items: selfCheckingController.countries.map((country) {
                        return DropdownMenuItem(value: country, child: Text(country['name']!));
                      }).toList(),
                      onChanged: (value) {
                        selfCheckingController.selectedCountry.value = value!;
                        selfCheckingController.fetchStates(value['code']!); // Use the country code for fetching states
                      },
                      decoration: const InputDecoration(labelText: "Country", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Country is required";
                        }
                        return null;
                      },
                    );
                  }),

                  const SizedBox(height: 16),

                  // Region/State Dropdown
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: selfCheckingController.regionState.value.isNotEmpty
                          ? selfCheckingController.regionState.value
                          : null,
                      items: selfCheckingController.states.map((state) {
                        return DropdownMenuItem(value: state, child: Text(state));
                      }).toList(),
                      onChanged: (value) => selfCheckingController.regionState.value = value!,
                      decoration: const InputDecoration(labelText: "Region/State", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Region/State is required";
                        }
                        return null;
                      },
                    );
                  }),

                  const SizedBox(height: 30),

                  // Next Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selfCheckingController.formKeyPage1.currentState!.validate()) {
                          // Form is valid, proceed to next page
                          Get.to(() => const SelfCheckInThreeSignatureInfo());
                        } else {
                          // Show error message
                          Get.snackbar("Error", "Please fill all mandatory fields.");
                        }
                      },
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


