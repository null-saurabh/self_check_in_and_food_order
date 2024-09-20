import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/admin/home_admin/widgets/add_food.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../orders_admin/admin_order_controller.dart';
import '../orders_admin/widgets/single_order.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminOrderListController>(
      init: AdminOrderListController(),
      builder: (orderController) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Home Admin",
                      style: AppWidget.HeadlineTextFeildStyle(),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/admin/add-menu');
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const AddFoodItem()),
                      // );
                    },
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  "assets/images/food.jpg",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 30.0),
                              const Text(
                                "Add Food Items",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/admin/check-in-list');
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> SelfCheckinList()));
                    },
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  "assets/images/food.jpg",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 30.0),
                              const Text(
                                "Self Checking List",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/admin/order-list');
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> SelfCheckinList()));
                    },
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  "assets/images/food.jpg",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 30.0),
                              const Text(
                                "Order List",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
