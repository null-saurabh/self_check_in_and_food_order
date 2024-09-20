import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wandercrew/pages/home_screen.dart';
import 'package:wandercrew/pages/menu_screen/menu_screen.dart';

import '../pages/self_checking_screen/self_check_in_one_document_info.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late SelfCheckInOneDocumentInfo selfcheckIn;
  late MenuScreen menuScreen;


  @override
  void initState() {
    selfcheckIn = SelfCheckInOneDocumentInfo();
    menuScreen = MenuScreen();
    pages = [menuScreen,selfcheckIn];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
