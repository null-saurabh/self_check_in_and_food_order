import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/select_room_screen/widgets/room_card.dart';

import '../homepage/home_screen_controller.dart';

class SelectRoomScreen extends StatelessWidget {
  final controller = Get.find<HomeScreenController>();

  SelectRoomScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Room'),
      ),
      body: ListView(
        children: [
          RoomCard(
            roomName: "Bed in 8-Bed Dormitory Room",
            price: 400,
            discount: "37% off",
            features: const [
              {"icon": Icons.wifi, "text": "Free Wifi"},
              {"icon": Icons.balcony, "text": "Balcony"},
              {"icon": Icons.park, "text": "Garden view"},
              {"icon": Icons.terrain, "text": "Mountain view"},
              {"icon": Icons.bathtub, "text": "Private bathroom"},
            ],
            taxes: 77,
            isBreakfastIncluded: false,
          ),
          RoomCard(
            roomName: "Deluxe Double or Twin Room with Mountain View",
            price: 400,
            discount: "37% off",
            features: const [
              {"icon": Icons.wifi, "text": "Free Wifi"},
              {"icon": Icons.balcony, "text": "Balcony"},
              {"icon": Icons.park, "text": "Garden view"},
              {"icon": Icons.terrain, "text": "Mountain view"},
              {"icon": Icons.bathtub, "text": "Private bathroom"},
            ],
            taxes: 77,
            isBreakfastIncluded: true,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Lets Go'),
        ),
      ),
    );
  }
}
