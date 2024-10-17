import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/cart_screen/widgets/bill_summary_widget.dart';
import 'package:wandercrew/pages/client/cart_screen/widgets/diner_info_widget.dart';
import 'package:wandercrew/pages/client/cart_screen/widgets/donation_widget.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import '../../../models/cart_model.dart';
import '../../../models/menu_item_model.dart';
import '../../../widgets/widget_support.dart';
import '../menu_screen/widgets/single_product.dart';
import '../self_checking_screen/widgets/gradient_texture.dart';
import 'cart_screen_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartScreenController>(
      init: CartScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xffF4F5FA),
          body: Stack(
              children: [
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 16.0, top: 132, bottom: 12),
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // White container with form and button

                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: controller.cartItems.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Center(
                                              child: Text('Your cart is empty')),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          AppElevatedButton(
                                            backgroundColor: Color(0xffFFDE1A),
                                            onPressed: () {
                                             controller.navigateToMenu(context);
                                            },
                                            title: "Menu",
                                            titleTextColor: Colors.black,
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        left: 12,
                                        right: 12,
                                      ),
                                      child: Obx(() {
                                        return ListView.builder(
                                          shrinkWrap:
                                              true, // This makes the ListView take only required height
                                          physics:
                                              const NeverScrollableScrollPhysics(), // Disables internal scrolling, lets parent handle scrolling
                                          itemCount: controller.cartItems.length,
                                          itemBuilder: (context, index) {
                                            String menuItemId = controller
                                                .cartItems.keys
                                                .elementAt(index);

                                            CartItemModel cartItem =
                                                controller.cartItems[menuItemId]!;
                                            MenuItemModel menuItem =
                                                cartItem.menuItem;

                                            return SingleProduct(
                                              menuItem: menuItem,
                                              isCart: true,
                                            );
                                          },
                                        );
                                      })),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const CartBillSummaryWidget(),
                            const SizedBox(
                              height: 16,
                            ),
                            const CartTipWidget(),
                            const SizedBox(height: 16.0),
                             CartCustomerInfoWidget(controller: controller,),
                            const SizedBox(height: 16.0),
                            AppElevatedButton(
                                width: 120,
                                title: "Pay Now",
                                titleTextColor: Colors.white,
                                titleTextSize: 16,
                                titleFontWeight: FontWeight.w400,
                                onPressed: () async {
                                  if (controller
                                      .cartDinnerInfoFormKey.currentState!
                                      .validate()) {
                                    await controller.initiatePayment(context);
                                  }
                                }
                                ),
                            const SizedBox(height: 24),
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
                                controller.receptionistText.value, // "Hi, "
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
                            // print("pressed");
                            // context.pop(); // Go back if there's a previous route
                            controller.navigateToMenu(context);

                          },
                          icon: const Icon(Icons.keyboard_backspace_rounded))),
                ),

          ]),
        );
      },
    );
  }
}
