import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final int price;
  final String discount;
  final List<Map<String, dynamic>> features; // Changed for icons and text
  final int taxes;
  final bool isBreakfastIncluded;

  const RoomCard({super.key,
    required this.roomName,
    required this.price,
    required this.discount,
    required this.features,
    required this.taxes,
    required this.isBreakfastIncluded,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Name
            Text(
              roomName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Room Info Row
            const Row(
              children: [
                Icon(Icons.person_outline, size: 16),
                SizedBox(width: 4),
                Text("Price for 1 adult"),
                SizedBox(width: 16),
                Icon(Icons.bed_outlined, size: 16),
                SizedBox(width: 4),
                Text("1 bunk bed"),
                SizedBox(width: 16),
                Icon(Icons.square_foot_outlined, size: 16),
                SizedBox(width: 4),
                Text("Room size: 14 m"),
              ],
            ),
            const SizedBox(height: 8),

            // Features Section
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: features
                  .map(
                    (feature) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(feature['icon'], size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 4),
                    Text(feature['text']),
                  ],
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 12),

            // Payment and Policy Info
            const Text(
              "❌ Total cost to cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  "No prepayment needed- pay at the property",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.credit_card_off, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  "No credit card needed",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Discount Section
            if (isBreakfastIncluded)
              const Row(
                children: [
                  Icon(Icons.free_breakfast, size: 16, color: Colors.green),
                  SizedBox(width: 4),
                  Text("Breakfast included"),
                ],
              ),
            const SizedBox(height: 8),
            const Text(
              "12% Genius discount",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Applied to the price before taxes and charges",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Pricing Section
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "37% off",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Genius discount",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Rs $price",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              "+Rs. $taxes taxes and charges",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Select Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Select"),
            ),
          ],
        ),
      ),
    );
  }
}