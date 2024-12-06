import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:wandercrew/pages/client/reception_home_screen/reception_controller.dart';
import 'package:wandercrew/pages/client/reception_home_screen/widgets/home_screen_menu_widget.dart';
import 'package:wandercrew/utils/routes.dart';

import '../../../widgets/widget_support.dart';

class ReceptionHomeScreen extends StatefulWidget {
  const ReceptionHomeScreen({super.key});

  @override
  State<ReceptionHomeScreen> createState() => _ReceptionHomeScreenState();
}


class _ReceptionHomeScreenState extends State<ReceptionHomeScreen> {

  @override
  void initState() {
    super.initState();
    // Preload the Lottie animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheLottieAnimation('assets/animation/drawer_ani.json');
    });
  }

// Helper function to preload Lottie animation
  Future<void> precacheLottieAnimation(String assetPath) async {
    await Lottie.asset(assetPath);
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceptionController>(
        init: ReceptionController(),
        builder: (controller) {
          final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
          return Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Drawer header
                   DrawerHeader(
                     padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: FutureBuilder(
                            future: precacheLottieAnimation('assets/animation/drawer_ani.json'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Lottie.asset(
                                  'assets/animation/drawer_ani.json',
                                  fit: BoxFit.contain,
                                );
                              } else {
                                // Placeholder while loading
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                        const Positioned(
                          top: 16,
                          left: 16,
                          right: 0,
                          child: Text(
                            'WanderCrew',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Title text overlay
                      ],
                    ),
                  ),

                  // Drawer items
                  ListTile(
                    leading: const Icon(Icons.contact_mail),
                    title: const Text('Contact Us'),
                    onTap: () {
                      context.go(Routes.contactUs); // Replace with your actual route
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About Us'),
                    onTap: () {
                      context.go(Routes.aboutUs); // Replace with your actual route
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.rule),
                    title: const Text('Terms and Conditions'),
                    onTap: () {
                      context.go(Routes.termAndCondition); // Replace with your actual route
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policies'),
                    onTap: () {
                      context.go(Routes.privacyPolicy); // Replace with your actual route
                    },
                  ),

                ],
              ),
            ),

            // backgroundColor: const Color(0xfffdfded),
            body: RefreshIndicator(
              onRefresh:controller.refreshPage,
              child: Container(
                // Apply the gradient background
                decoration: const BoxDecoration(

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF887CC8), // Starting color
                      Color(0xFFA1D5DF), // Middle color
                      Color(0xFFABF8E8), // End color
                    ],
                    stops: [
                      0.2746,  // 27.46%
                      0.7713,  // 77.13%
                      1.2076,  // 120.76% (Note: values above 1 are clipped)
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/textures/reception_noise.png'), // Replace with your image path
                    fit: BoxFit.cover, // To make the image cover the entire container
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("WANDER",
                                    style: AppWidget.white32Heading700TextStyle()),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text("CREW",
                                    style: AppWidget.headingBoldTextStyle()),
                              ],
                            ),
                            Text("Your Journey, Our Passion.",
                                style: AppWidget.white12SubHeadingTextStyle()),
                            const SizedBox(
                              height: 48,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ReceptionHomeGridItem(
                                      height: 249,
                                      iconWidth: 152,
                                      iconHeight: 152,
                                      isCheckIn: true,
                                      icon: "assets/icons/check_in.png",
                                      label: "Check In",
                                      onTap: () {
                                        // Add action for check-in
                                        context.go(Routes.receptionCheckIn);

                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ReceptionHomeGridItem(
                                      height: 83,
                                      isRoomService: true,
                                      labelIcon: const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      label: "Room Service",
                                      onTap: () {
                                        // context.go(Routes.receptionTrackOrder);

                                        controller.showAdminContacts(context);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ReceptionHomeGridItem(
                                      height: 199,
                                      icon: "assets/icons/burger.png",
                                      label: "Order Food",
                                      onTap: () {
                                        // Add action for order food
                                        context.go(Routes.receptionMenu);

                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ReceptionHomeGridItem(
                                      height: 133,
                                      iconHeight: 108,
                                      iconWidth: 94,
                                      isTrackOrder: true  ,
                                      icon: "assets/icons/track_order.png",
                                      label: "Track Order",
                                      onTap: () {
                                        context.go(Routes.receptionTrackOrder);

                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
