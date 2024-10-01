import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/menu_screen_controller.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/scrollable_category_picker.dart';
import 'package:wandercrew/utils/routes.dart';
import 'package:wandercrew/widgets/widget_support.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
      init: MenuScreenController(),
      builder: (controller) {
        return Stack(
          children: [


            Padding(
              padding: const EdgeInsets.only(right: 6),//16.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'MENU',
                        style: AppWidget.headingBoldTextStyle(),
                      ),
                    ),
                    const Expanded(
                      child: ScrollableMenuCategoryPicker()),

                  ],
                ),
              ),
            ),
            Positioned(
              top: 18,
              right:-12,
              child: GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.receptionCart);
                },
                child: Image.asset(
                  'assets/icons/menu_sandwich.png', // Your sandwich image
                  height: 112,
                  width: 84,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
