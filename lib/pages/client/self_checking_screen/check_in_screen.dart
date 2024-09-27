import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';


class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
        init: CheckInController(),
    builder: (menuScreenController) {
    return Scaffold(
    backgroundColor: const Color(0xfffdfded),
    );
    }
    );
  }
}
