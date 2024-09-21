import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/login_admin/admin_login.dart';
import 'package:wandercrew/pages/cart_screen/cart_screen.dart';
import 'package:wandercrew/pages/menu_screen/menu_screen_controller.dart';
import 'package:wandercrew/pages/menu_screen/widgets/single_product.dart';
import '../../widgets/widget_support.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
      init: MenuScreenController(),
        builder:(menuScreenController) {
        return Scaffold(
          body: SingleChildScrollView(child: Container(
            margin: const EdgeInsets.only(top: 50.0, left: 20.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector( onTap: (){
                      Get.toNamed('/admin-login');

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminLogin()));
                    },child: Text("Wander Crew,", style: AppWidget.boldTextFeildStyle())),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed('/cart');
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text("Food Menu", style: AppWidget.HeadlineTextFeildStyle()),
                Text("Discover and Get Great Food",
                    style: AppWidget.LightTextFeildStyle()),
                const SizedBox(
                  height: 20.0,
                ),
                Container(margin: const EdgeInsets.only(right: 20.0), child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        menuScreenController.isVeg.value = true;
                        menuScreenController.isNonVeg.value = false;
                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: menuScreenController.isVeg.value ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/images/ice-cream.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            color: menuScreenController.isVeg.value ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () {
                        menuScreenController.isVeg.value = false;
                        menuScreenController.isNonVeg.value = true;

                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: menuScreenController.isNonVeg.value ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/images/pizza.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            color: menuScreenController.isNonVeg.value ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),

                  ],
                )),
                const SizedBox(
                  height: 30.0,
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Breakfast'),
                ),
                SizedBox(
                  height: 4000,
                  child: Column(
                    children: menuScreenController.getBreakfastMenuDataList.map(
                          (breakfastMenuData) {
                            // print("AAAAABB " + breakfastMenuData.productImage);
                        return SingleProduct(
                          productId: breakfastMenuData.productId,
                          productPrice: breakfastMenuData.productPrice,
                          productImage: breakfastMenuData.productImage,
                          productName: breakfastMenuData.productName,
                        );
                      },
                    ).toList(),
                    // children: [

                    // ],
                  ),
                ),
              ],
            )
              ],
            ),
          )),
        );
        }
    );
  }



}

