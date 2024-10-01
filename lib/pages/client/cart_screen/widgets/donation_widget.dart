import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/widget_support.dart';
import '../cart_screen_controller.dart';

class CartTipWidget extends StatelessWidget {

  const CartTipWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:Row(

            children: [
              Obx((){
                CartScreenController controller = Get.find<CartScreenController>();
                return Checkbox(
                  value: controller.isTipSelected.value, // Boolean value to handle selection
                  onChanged: (bool? value) {
                    // Handle the selection change
                    controller.isTipSelected.value = value!;
                    controller.calculateTipAmount();
                  },
                  shape: const CircleBorder(), // Making the checkbox circular
                  activeColor: const Color(0xffE7C64E), // Active color when selected
                );}),
              const SizedBox(width: 8,),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Donate to Wander Crew Team",style: AppWidget.black16Text500Style(),),
                  Text("Support us to improve ourself.",style: AppWidget.black12Text500Style(),)
                ],
              ),
              const Spacer(),
              Image.asset("assets/icons/tip_icon.png",height: 40,width: 40,)
            ],
          )
      ),
    );
  }
}
