import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Effective Date: 01/11/2024\n\n"
                  "This Privacy Policy describes how we collect, use, and protect your personal information when you use our website and app ('Service'). By using the Service, you agree to the terms outlined in this policy.\n\n"
                  "1. Information We Collect:\n"
                  "- Personal Information: We collect details like name, email, Aadhar card, address, and phone number for self check-in.\n"
                  "- Payment Information: Razorpay payment details when food orders are placed.\n"
                  "- Order Details: Information about your food order, delivery status, etc.\n"
                  "- Usage Data: Information on how you use the Service, including device and browser information.\n\n"
                  "2. How We Use Your Information:\n"
                  "- To process your self check-in and store it in our database.\n"
                  "- To handle food orders, payments, and customer support.\n"
                  "- To improve our services and provide you with a better user experience.\n\n"
                  "3. Sharing Your Information:\n"
                  "- We do not share your personal data except with service providers like Razorpay or as required by law.\n\n"
                  "4. Data Security:\n"
                  "We implement reasonable measures to protect your personal data, but no method is completely secure.\n\n"
                  "5. Your Rights:\n"
                  "- You can request access to your personal data and request modifications or deletions.\n\n"
                  "6. Refund Data:\n"
                  "- For any refunds processed, we may collect additional data as required by Razorpay or relevant authorities for processing the refund securely.\n\n"
                  "For further inquiries, contact us at wandercrew9@gmail.com.",

              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
