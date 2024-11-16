import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to WanderCrew Hostel",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Your cozy escape nestled in the heart of Manali. "
                  "Situated just 1.2 km from Manali Mall Road, we offer a unique blend of comfort, community, and adventure. "
                  "Our hostel is designed for travelers who seek budget-friendly stays with a vibrant, home-like atmosphere. "
                  "With dormitory and deluxe rooms, we cater to solo adventurers, couples, group travelers, college students, and more.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "At WanderCrew, you’ll find more than just a place to rest your head. "
                  "Enjoy movie nights in the garden on our projector screen, relax with music amidst the greenery, "
                  "or share stories over a warm bonfire. Our rooftop café serves delicious continental, Italian, "
                  "and Indian dishes, along with freshly brewed tea and coffee. Whether you’re here for the serene views "
                  "or the social vibe, we promise to make your stay unforgettable.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Image.network(
              'https://your-hostel-image-url.jpg',  // Replace with actual image URL
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              "Come stay with us and make memories that last a lifetime!",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
