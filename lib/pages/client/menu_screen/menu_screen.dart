import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/client/menu_screen/widgets/single_product.dart';
import '../../../models/menu_item_model.dart';
import '../../../widgets/widget_support.dart';
import 'menu_screen_controller.dart';


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
                      Get.toNamed('/admin/login');

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminLogin()));
                    },child: Text("Wander Crew,", style: AppWidget.headingBoldTextStyle())),
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
                Text("Food Menu", style: AppWidget.subHeadingTextStyle()),
                Text("Discover and Get Great Food",
                    style: AppWidget.light16TextStyle()),
                const SizedBox(
                  height: 20.0,
                ),
                Container(margin: const EdgeInsets.only(right: 20.0), child:                     buildVegNonVegFilter(menuScreenController),
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
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        controller.toggleCategoryExpansion(index);
      },
      children: controller.filteredMenuByCategory.entries
          .where((entry) => entry.value.isNotEmpty) // Filter out empty categories
          .toList()
          .asMap()
          .map((index, entry) => MapEntry(
        index,
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                entry.key,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Column(
            children: entry.value.map((menuItem) {
              return SingleProduct(menuItem: menuItem);
            }).toList(),
          ),
          isExpanded: controller.expandedCategories[index],
        ),
      ))
          .values
          .toList(),
    );
  }


}

