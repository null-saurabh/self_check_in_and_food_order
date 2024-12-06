import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  final String address = "Durga Ashram Gali, Sheikhpura Bagicha, Patna, Bihar Pin - 800014";
  final String phone1 = "9709568649";
  final String phone2 = "8597788095";
  final String email = "wandercrew9@gmail.com";

  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We’d love to hear from you!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Whether you have questions, want to book a stay, or have suggestions, here's how you can reach us:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Address:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Phone:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _makePhoneCall(phone1),
              child: Text(
                phone1,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            GestureDetector(
              onTap: () => _makePhoneCall(phone2),
              child: Text(
                phone2,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Email:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _sendEmail(email),
              child: Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Social Media:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchURL("https://www.instagram.com/wandercrew.in/"),
              child: const Text(
                "Instagram: https://www.instagram.com/wandercrew.in/",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            GestureDetector(
              onTap: () => _launchURL("https://www.facebook.com/profile.php?id=61565214073072"),
              child: const Text(
                "Facebook: https://www.facebook.com/profile.php?id=61565214073072",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            GestureDetector(
              onTap: () => _launchURL("https://x.com/wandercrewin"),
              child: const Text(
                "X (Twitter): https://x.com/wandercrewin",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            GestureDetector(
              onTap: () => _launchURL("https://www.youtube.com/@wandercrewin"),
              child: const Text(
                "YouTube: https://www.youtube.com/@wandercrewin",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper functions to handle actions
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launch(launchUri.toString());
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(emailLaunchUri.toString());
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
