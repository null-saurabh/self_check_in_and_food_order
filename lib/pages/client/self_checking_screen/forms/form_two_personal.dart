import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import '../../../../widgets/app_dropdown.dart';
import '../../../../widgets/edit_text.dart';
import '../../../../widgets/text_view.dart';
import '../../../../widgets/widget_support.dart';

class CheckInFormTwoPersonal extends StatelessWidget {
  const CheckInFormTwoPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
      init: CheckInController(),
      builder: (selfCheckingController) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Form(
            key: selfCheckingController.formKeyPage2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                EditText(
                  labelText: "Your Name*",
                  hint: "Enter Full Name",
                  controller: selfCheckingController.fullName,
                  onValidate: Validators.requiredField,
                ),

                // Email Address
                EditText(
                  labelText: "Your Email Address",
                  hint: "Enter Your Email Address",
                  inputType: TextInputType.emailAddress,
                  controller: selfCheckingController.email,
                  onValidate: (p0) {
                    return Validators.validateEmail(p0);
                  },
                ),

                // Contact with Country Code Dropdown
                EditText(
                  labelText: "Contact",
                  hint: "Enter Contact Number",
                  inputType: TextInputType.number,
                  controller: selfCheckingController.contact,
                  onValidate: (p0) {
                    return Validators.validatePhoneNumber(p0);
                  },
                  prefixSize: 71,
                  prefixHeight: 40,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: AppDropDown(
                      items:
                          selfCheckingController.countryCodes.map((codeData) {
                        return DropdownMenuItem(
                          value: codeData['code'],
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  codeData['flag'] ??
                                      '', // Default to empty string if flag is null
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons
                                        .flag); // Provide a fallback if flag image fails to load
                                  },
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  width: 34,
                                  child: Text(
                                    codeData['code']!.removeAllWhitespace,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow
                                        .ellipsis, // Safeguard to handle overflow
                                    maxLines: 1,
                                  ),
                                ), // Safely use code as text
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChange: (value) {
                        if (value != null) {
                          selfCheckingController.selectedCountryCode.value =
                              value;
                        } else {}
                      },
                      // value: selfCheckingController.selectedCountryCode.value,
                      value: selfCheckingController
                              .selectedCountryCode.value.isNotEmpty
                          ? selfCheckingController.selectedCountryCode.value
                          : '+91',
                      // labelText: "Code",
                      oneSideBorder: true,
                      contentPadding: const EdgeInsets.all(0),
                      height: 39,
                      width: 69,
                      dropDownWidth: 200,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.4),
                      showSearch: true,
                      searchCtrl: TextEditingController(),
                      searchMatchFn: (item, searchValue) {
                        searchValue = searchValue.toLowerCase();
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue);
                      },
                    ),
                  ),
                ),

                // Age
                EditText(
                  labelText: "Age*",
                  hint: "Enter Age",
                  inputType: TextInputType.number,
                  controller: selfCheckingController.age,
                  onValidate: Validators.requiredField,
                ),


                // Gender Dropdown
                FormField<String>(validator: (value) {
                  if (selfCheckingController.gender.value == null) {
                    return "Please select a gender";
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextView(
                          "Gender*",
                          textColor: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ChoiceChip(
                                  label: const Text("M"),
                                  backgroundColor: const Color(0xffECFDFC),
                                  selectedColor: const Color(0xffECFDFC),
                                  disabledColor: const Color(0xffECFDFC),
                                  selected:
                                      selfCheckingController.gender.value ==
                                          "M",
                                  side: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  onSelected: (isSelected) {
                                    selfCheckingController.gender.value =
                                        isSelected ? "M" : null;
                                  }),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text("F"),
                                backgroundColor: const Color(0xffECFDFC),
                                selectedColor: const Color(0xffECFDFC),
                                side: const BorderSide(
                                    width: 1, color: Colors.grey),
                                selected:
                                    selfCheckingController.gender.value == "F",
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onSelected: (isSelected) {
                                  selfCheckingController.gender.value =
                                      isSelected ? "F" : null;
                                },
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text("Other"),
                                backgroundColor: const Color(0xffECFDFC),
                                selectedColor: const Color(0xffECFDFC),
                                side: const BorderSide(
                                    width: 1, color: Colors.grey),
                                selected:
                                    selfCheckingController.gender.value == "0",
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onSelected: (isSelected) {
                                  selfCheckingController.gender.value =
                                      isSelected ? "0" : null;
                                },
                              ),
                            ],
                          );
                        }),
                        if (formState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              formState.errorText ?? '',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 211, 63, 63),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ]);
                }),
                SizedBox(height: 12,),
                EditText(
                  labelText: "Arriving From*",
                  hint: "Enter Place",
                  controller: selfCheckingController.arrivingFromController,
                  onValidate: Validators.requiredField,
                ),
                EditText(
                  labelText: "Going To*",
                  hint: "Enter Place",
                  controller: selfCheckingController.goingToController,
                  onValidate: Validators.requiredField,
                ),


                // Next Button
              ],
            ),
          ),
        );
      },
    );
  }
}
