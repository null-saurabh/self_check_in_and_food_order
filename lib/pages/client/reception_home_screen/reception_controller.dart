import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceptionController extends GetxController{

  void makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+919709568649',
    );
    if (await canLaunchUrl(launchUri)) {
      // print("12345");
      await launchUrl(launchUri);
      // print("12345m");

    } else {
      // print("12345l");

      Get.snackbar('Error', 'Failed to fetch orders');
      // Handle error here, if the phone call cannot be made.
      // print("Could not launch $phoneNumber");
    }
  }


}