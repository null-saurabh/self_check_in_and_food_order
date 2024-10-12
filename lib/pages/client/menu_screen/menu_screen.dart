import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/expandable_menu_item.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/menu_button.dart';
import 'package:wandercrew/utils/routes.dart';
import '../../../widgets/widget_support.dart';
import '../cart_screen/cart_screen_controller.dart';
import '../self_checking_screen/widgets/gradient_texture.dart';
import 'menu_screen_controller.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder: (menuScreenController) {
          CartScreenController controller = Get.put(CartScreenController());

          return Scaffold(
            backgroundColor: const Color(0xffF4F5FA),
            body: Stack(children: [
              // The gradient image at the bottom right corner
              // Using the helper function to add gradient textures
              const BackgroundGradientTexture(
                top: 48,
                right: -38,
                assetPath: 'assets/textures/menu_texture_2.png',
              ),
              const BackgroundGradientTexture(
                top: 68,
                right: 116,
                width: 79,
                height: 116,
                assetPath: 'assets/textures/menu_texture_4.png',
              ),
              const BackgroundGradientTexture(
                top: 188,
                right: 116,
                width: 79,
                height: 116,
                assetPath: 'assets/textures/menu_texture_4.png',
              ),
              const BackgroundGradientTexture(
                top: 48,
                left: -36,
                assetPath: 'assets/textures/menu_texture_1.png',
              ),
              const BackgroundGradientTexture(
                top: 16,
                right: 122,
                width: 70,
                height: 77,
                assetPath: 'assets/textures/menu_texture_3.png',
              ),
              const BackgroundGradientTexture(
                bottom: 60,
                left: -36,
                assetPath: 'assets/textures/menu_texture_1.png',
              ),
              const BackgroundGradientTexture(
                bottom: 60,
                right: -38,
                assetPath: 'assets/textures/menu_texture_2.png',
              ),

              Positioned(
                top: 32,
                left: 16,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.receptionHome);
                        },
                        icon: const Icon(Icons.keyboard_backspace_rounded))),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 16.0, top: 132, bottom: 0),
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // White container with form and button

                      const Column(
                        children: [
                          SizedBox(height: 88, child: MenuButton()),
                          SizedBox(height: 8),
                          Expanded(child: ExpandableMenuItem()),
                          // SizedBox(height:8),
                        ],
                      ),

                      // Girl's image positioned at the top left of the container
                      Positioned(
                        top: -124,
                        right: 0,
                        child: Image.asset(
                          'assets/icons/cafe_receptionist.png', // Replace with your image asset path
                          width: 124,
                          height: 124,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Speech bubble container next to the girl image
                      Positioned(
                        top: -76,
                        right: 108,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 145,
                          // height: 52,
                          decoration: const BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12)),
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/textures/cafe_receptionist_texture.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              menuScreenController
                                  .receptionistText.value, // "Hi, "
                              style: AppWidget
                                  .white12Bold600TextStyle(), // Regular style
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Obx(() {
                return controller.itemTotalAmount == 0
                    ? SizedBox()
                    : Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          onTap: (){
                            Get.toNamed(Routes.receptionCart);
                          },
                          child: Container(
                            height: 32,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // Apply linear gradient
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFD69052), // #D69052
                                  Color(0xFFE7C64E), // #E7C64E
                                ],
                                stops: [
                                  0.0884,
                                  1.0694
                                ], // These values correspond to the percentages in the gradient
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  return Text(
                                    "${controller.totalQuantity} item added",
                                    style: TextStyle(color: Colors.white),
                                  );
                                }),
                                Icon(Icons.arrow_forward_outlined,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      );
                // Return an empty widget if there are no cart items
              }),
            ]),
          );
        });
  }
}
