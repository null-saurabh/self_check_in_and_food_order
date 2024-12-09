import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenController extends GetxController {

  var startDate = DateTime.now().obs; // Default to today
  var focusedDay = DateTime.now().obs; // Default to today
  var endDate = DateTime.now().add(const Duration(days: 1)).obs; // Default to tomorrow
  final String googleMapsUrl = 'https://maps.app.goo.gl/Uxhksgkm1aEoXuoa9';

// Guests variable
  RxInt adults = 1.obs;

  Future<void> openMap() async {
    if (
    await canLaunch(googleMapsUrl)
    )
    {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }


  // Utility method to reset data if needed
  void reset() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now().add(const Duration(days: 1));
    adults.value = 1;
  }

}