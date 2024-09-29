import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
class ReceptionController extends GetxController{

  // void makePhoneCall() async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: '+919709568649',
  //   );
  //   if (await canLaunchUrl(launchUri)) {
  //     await launchUrl(launchUri);
  //   } else {
  //     Get.snackbar('Error', 'Failed to fetch orders');
  //   }
  // }

  // void makePhoneCall() async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: '+919709568649',
  //   );
  //   // Directly launch the URL
  //   try {
  //     await launchUrl(launchUri);
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to initiate phone call: $e');
  //   }
  // }

  void makePhoneCall() {
    final String phoneNumber = '+919709568649';
    html.window.open('tel:$phoneNumber', '_self');
  }



}