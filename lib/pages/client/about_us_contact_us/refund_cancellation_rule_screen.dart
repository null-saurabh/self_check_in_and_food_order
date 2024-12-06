import 'package:flutter/material.dart';

class RefundCancellationPolicyPage extends StatelessWidget {
  const RefundCancellationPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Refund and Cancellation Policy")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Effective Date: 01/11/2024\n\n"
                  "This Refund and Cancellation Policy applies to all purchases made through our Service.\n\n"
                  "1. Refund Eligibility:\n"
                  "- Refunds are available for cancellations made within 24 hours of placing the order, provided the order has not yet been processed or delivered.\n"
                  "- If the order has been processed, refunds will be made only in case of service failure or incorrect deliveries.\n"
                  "- Refund requests must be made within 7 days of the purchase date.\n\n"
                  "2. Refund Process:\n"
                  "- Upon receipt of your refund request, we will investigate and respond within 5-7 working days.\n"
                  "- Once approved, the refund will be processed and credited to your original method of payment within 5-7 working days.\n"
                  "- Refunds will be communicated via email confirmation once processed.\n\n"
                  "3. Cancellation:\n"
                  "- Orders can be canceled only if the cancellation request is made within 24 hours of placing the order and before it is processed.\n"
                  "- To cancel an order, please contact us immediately at [your contact details].\n\n"
                  "4. Exceptions:\n"
                  "- Refunds are not applicable to digital goods or services that have been delivered as described.\n"
                  "- Orders that have been processed, delivered, or consumed are non-refundable.\n\n"
                  "For further inquiries regarding our Refund and Cancellation Policy, contact us at wandercrew9@gmail.com.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
