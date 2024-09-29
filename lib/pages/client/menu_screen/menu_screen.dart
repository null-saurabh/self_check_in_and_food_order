import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/single_product.dart';
import '../../../widgets/widget_support.dart';
import '../cart_screen/cart_screen_controller.dart';
import 'menu_screen_controller.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
      init: MenuScreenController(),
        builder:(menuScreenController) {
        return Scaffold(
          backgroundColor: const Color(0xffF4F5FA),
          body: SingleChildScrollView(child: Container(
            margin: const EdgeInsets.only(top: 32.0, left: 20.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                IconButton(
                    onPressed: () {
                        Get.back();
                    },
                    icon: const Icon(Icons.keyboard_backspace_rounded)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector( onTap: (){
                      Get.toNamed('/admin/login');

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminLogin()));
                    },child: Text("Wander Crew,", style: AppWidget.headingBoldTextStyle())),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/reception/menu/cart');
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
                      },
                      child: Stack(
                        children: [
                          Obx(() => Positioned(
                            right: 10,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${Get.put(CartScreenController()).cartItems.length}', // Replace with your CartScreenController instance
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )),

                          SizedBox(
                            height: 60,
                            width: 60,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                padding: const EdgeInsets.all(4),

                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // Display cart item count
                        ],
                      ),
                    )


                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text("Food Menu", style: AppWidget.subHeadingTextStyle()),
                Text("Discover and Get Great Food",
                    style: AppWidget.black16Text400Style()),
                const SizedBox(
                  height: 20.0,
                ),
                Container(margin: const EdgeInsets.only(right: 16.0), child:                     buildVegNonVegFilter(menuScreenController),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                buildExpandableMenu(menuScreenController),
              ],
            ),
          )),
        );
        }
    );
  }


  // Build Veg/Non-Veg filter buttons
  Widget buildVegNonVegFilter(MenuScreenController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.toggleVegFilter(),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: controller.isVegSelected.value ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: controller.isVegSelected.value ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => controller.toggleNonVegFilter(),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: controller.isNonVegSelected.value ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: controller.isNonVegSelected.value ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build Expandable List of Categories
  Widget buildExpandableMenu(MenuScreenController controller) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for parent list
      shrinkWrap: true, // Allow the ListView to take only the necessary height
      children: controller.filteredMenuByCategory.entries
          .where((entry) => entry.value.isNotEmpty) // Filter out empty categories
          .map((entry) {
        int index = controller.filteredMenuByCategory.keys.toList().indexOf(entry.key);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.toggleCategoryExpansion(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  border: const Border(bottom: BorderSide.none,),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      controller.expandedCategories[index]
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                  ],
                ),
              ),
            ),
            if (controller.expandedCategories[index]) ...[ // Show items only if expanded
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     spreadRadius: 1,
                    //     blurRadius: 5,
                    //   ),
                    // ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: entry.value.map((menuItem) {
                      return SingleProduct(menuItem: menuItem);
                    }).toList(),
                  ),
                ),
              ),]
          ],
        );
      }).toList(),
    );
  }


}

