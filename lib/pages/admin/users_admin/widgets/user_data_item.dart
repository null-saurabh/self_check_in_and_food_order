import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/models/user_model.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';

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
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.2),
            //     spreadRadius: 0.1,
            //     blurRadius: 8,
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoRow(label: 'Name',value:userData.name ),
                _buildInfoRow(label: 'Username',value:userData.userId),
                _buildPasswordRow(),
                _buildInfoRow(label: 'Role',value:userData.role,noBottomPadding: true ),
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
                SizedBox(height: 4,),
                // _buildInfoRow('Last Login', userData.loginData.last.toString()),

                Row(
                  children: [
                    AppElevatedButton(
                      title: "Edit",
                      titleTextColor: Colors.white,
                      backgroundColor: Color(0xff007AFF),
                      onPressed: (){},
                    ),
                    SizedBox(width: 8,),
                    AppElevatedButton(
                      title: "Delete",
                      titleTextColor: Colors.white,
                      backgroundColor: Colors.black,
                      onPressed: (){
                        controller.deleteUser(userData);
                      },
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: (){

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
    );;
    } );
  }


  Widget _buildInfoRow({required String label, String? value, bool? noBottomPadding, bool? noTopPadding}) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppWidget.black16Text400Style(),
        ),
        Expanded(
          child: Text(value ?? "", style: AppWidget.black16Text600Style()),
        ),
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
