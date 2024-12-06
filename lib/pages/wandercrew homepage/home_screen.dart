import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/book_now_section/book_now_section.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/cafe_section/cafe_section.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/footer_section/footer_section.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/last_section/last_section.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/offer_section/offer_section.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/why_wandercrew_section/why_wandercrew_section.dart';
import 'home_screen_controller.dart';

class WanderCrewHomePage extends StatefulWidget {
  const WanderCrewHomePage({super.key});

  @override
  State<WanderCrewHomePage> createState() => _WanderCrewHomePageState();
}

class _WanderCrewHomePageState extends State<WanderCrewHomePage> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (controller) {
          final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
          return Scaffold(
            key: scaffoldKey,
            body: SingleChildScrollView(
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
                  const OfferSectionHomepage(),
                   BookNowSectionHomePage(),
                  const WhyWandercrewSectionHomepage(),
                  GestureDetector(
                    onTap: controller.openMap,
                    child: Image.asset(
                      "assets/images/map.jpg",
                      // height: 156,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const CafeSectionHomePage(),
                  const LastSectionHomepage(),
                  const FooterSection()
                ],
              ),
            )
          );
        });
  }
}


