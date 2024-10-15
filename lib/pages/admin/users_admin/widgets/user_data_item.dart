import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/user_model.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';

import '../../../../utils/date_time.dart';
import '../../../../widgets/widget_support.dart';
import '../manage_user_controller.dart';

class UserDataItemAdmin extends StatelessWidget {
  final AdminUserModel userData;

  const UserDataItemAdmin({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageUserAdminController>(
        init: ManageUserAdminController(),
    builder: (controller) {


    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.black.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoRow(label: 'Name',value:userData.name ),
                    GestureDetector(
                      onTap: () {
                        controller.downloadUserData(context,userData);
                      },
                      child: const Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                _buildNumberRow( onCallPressed: (){controller.makePhoneCall(userData.number);} ),
                _buildInfoRow(label: 'Username',value:userData.userId),
                _buildPasswordRow(),
                _buildInfoRow(label: 'Role',value:userData.role),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Online",style: AppWidget.black16Text400Style(),),
                    Transform.scale(
                      scale: 0.8, // Adjust the scale factor to decrease the size
                      child: Switch(
                        value: userData.isOnline,
                        activeColor: Colors.white,
                        activeTrackColor: Color(0xff2563EB),
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                        onChanged: (bool value) {
                          controller.toggleUserOnlineStatus(userData, value);
                          // controller.isVeg.value = value;
                        },
                      ),
                    )

                  ],
                ),
                _buildInfoRow(label: 'Last Login', value: DateTimeUtils.formatDateTime(userData.loginData.last,format: "dd-MMM HH:mm a"),),
                SizedBox(height: 16,),

                Row(
                  children: [
                    AppElevatedButton(
                      title: "Edit",
                      titleTextColor: Colors.white,
                      backgroundColor: Color(0xff007AFF),
                      onPressed: (){
                        controller.editUserData(userData);
                      },
                    ),
                    SizedBox(width: 8,),
                    AppElevatedButton(
                      title: "Delete",
                      titleTextColor: Colors.white,
                      backgroundColor: Colors.black,
                      onPressed: (){
                        controller.deleteUser(context,userData);
                      },
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Login History",style: AppWidget.black16Text600Style()),
                                  Divider(color: Colors.grey), // Divider below heading
                                  // If loginData is not null, show the login dates
                                  if (userData.loginData.isNotEmpty)
                                    ...userData.loginData
                                        .reversed
                                        .take(10) // take the last 10 entries
                                        .map(
                                          (loginDate) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(DateTimeUtils.formatDateTime(loginDate,format: "dd-MMM HH:mm a"), // Use your preferred date format
                                                style: AppWidget.black16Text400Style()),
                                            SizedBox(width: 4,),
                                            Text("Login",
                                                style:  AppWidget.black16Text400Style()),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text("No history available."),
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.history,color: Colors.black,),
                    )

                  ],
                )

              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

      ],
    );
    } );
  }


  Widget _buildInfoRow({required String label, String? value}) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppWidget.black16Text400Style(),
        ),
        Text(value ?? "", style: AppWidget.black16Text600Style()),
      ],
    );
  }

  Widget _buildNumberRow({required VoidCallback onCallPressed}) {
    return Row(
      children: [
        Text(
          'Number: ',
          style: AppWidget.black16Text400Style(),
        ),
        Text(userData.number, style: AppWidget.black16Text600Style()),
        SizedBox(width: 4,),
        GestureDetector(
          onTap: onCallPressed,
          child: Icon(Icons.call,color: Colors.green,size: 20,),
        )
      ],
    );
  }
  Widget _buildPasswordRow() {
    final RxBool isPasswordVisible = false.obs;

    return Obx(() => Row(
      children: [
        Text('Password: ', style: AppWidget.black16Text400Style(),),
        Expanded(
          child: Text(
            isPasswordVisible.value ? userData.password : '••••••••',
            style: AppWidget.black16Text600Style(),
          ),
        ),
        GestureDetector(
          onTapDown: (_) {
            isPasswordVisible.value = true;
          },
          onTapUp: (_) {
            isPasswordVisible.value = false;
          },
          onTapCancel: () {
            isPasswordVisible.value = false;
          },
          child: Icon(
            isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ],
    ));
  }


}
