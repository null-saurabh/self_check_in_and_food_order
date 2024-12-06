import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/routes.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms and Conditions")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Terms and Conditions",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Effective Date: 01/11/2024\n\n"
                  "These Terms and Conditions ('Terms') govern the use of our website and app ('Service'). By using the Service, you agree to comply with and be bound by the following terms.\n\n"
                  "1. Eligibility:\n"
                  "- You must be 18 years or older to use this Service.\n\n"
                  "2. Account Responsibilities:\n"
                  "- You agree to provide accurate and complete information during the check-in process.\n"
                  "- You are responsible for maintaining the confidentiality of your account information.\n\n"
                  "3. Payment and Orders:\n"
                  "- Payments for food orders are processed securely via Razorpay.\n"
                  "- You agree to pay for any orders placed through the Service.\n\n"
                  "4. Use of Service:\n"
                  "- You agree to use the Service for lawful purposes only, including the self check-in and food ordering features.\n"
                  "- Unauthorized use of the Service may result in termination of access.\n\n"
                  "5. Limitation of Liability:\n"
                  "- We are not liable for any indirect or consequential damages resulting from your use of the Service.\n\n"
                  "6. Termination:\n"
                  "- We reserve the right to suspend or terminate your access to the Service for any violation of these Terms.\n\n"
                  "7. Governing Law:\n"
                  "- These Terms are governed by the laws of India. Disputes will be resolved in the courts of Patna.\n\n"
                  "8. Changes to Terms:\n"
                  "- We may update these Terms at any time. Continued use of the Service constitutes acceptance of any changes.\n\n"
                  "For any inquiries or complaints, contact us at wandercrew9@gmail.com.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go(Routes.privacyPolicy); // Navigate to Privacy Policy page
                      },
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      ",",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.go(Routes.refundCancellation); // Navigate to Privacy Policy page
                      },
                      child: const Text(
                        "Refund/Cancellation Policy",
                        style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      ",",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.go(Routes.contactUs); // Navigate to Contact Us page
                      },
                      child: const Text(
                        "Contact Us",
                        style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      ",",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.go(Routes.aboutUs); // Navigate to About Us page
                      },
                      child: const Text(
                        "About Us",
                        style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
