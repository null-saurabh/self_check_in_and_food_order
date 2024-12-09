import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/routes.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              child: Lottie.asset(
                'assets/animation/drawer_ani.json',
                fit: BoxFit.contain,
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
              context.go(
                  Routes.termAndCondition); // Replace with your actual route
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policies'),
            onTap: () {
              context
                  .go(Routes.privacyPolicy); // Replace with your actual route
            },
          ),
        ],
      ),
    );
  }
}
