import 'dart:convert';
import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:wandercrew/pages/admin/orders_admin/admin_order_controller.dart';


class RazorpayService {


  void openCheckout({
    required BuildContext buildContext,
    required String key,
    required int amount,
    required String number,
    required String name,
    required Function onSuccess,
    required Function onFail,
    required Function onDismiss})
  async {

    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );


    final url = 'https://us-central1-wander-crew.cloudfunctions.net/createOrder';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'name': name,
        'contact': number,
        'description': 'name: $name, number: $number,orderDate: ${DateTime.now()}',
      }),
    );

    buildContext.pop();

    if (response.statusCode == 200) {
      final orderData = jsonDecode(response.body);
    final options = js.JsObject.jsify({
      'key': key,
      'amount': orderData['amount'], // Amount in paise
      'order_id': orderData['id'],
      'name': 'WanderCrew',
      'description': 'Payment for WanderCrew services',
      'prefill': {
        'name': name,
        'contact': number,
        // 'email': 'email@example.com',
      },
      'theme': {
        'color': '#F37254'
      },
        'handler': js.allowInterop((response) {
        handlePaymentSuccess(buildContext,response,onSuccess);
    }),
        'modal': {
          'ondismiss': js.allowInterop(() {
            handlePaymentDismiss(onDismiss);
          })
        }
    });

    final rzp = js.context.callMethod('Razorpay', [options]);

    rzp.callMethod('open');

      // Optionally handle the payment failure using the handler itself
      rzp.callMethod('on', ['payment.failed', js.allowInterop((response) {
        handlePaymentFailure(response, onFail);
      })]);

    // js.context['Razorpay'].callMethod('on', ['payment.failed', js.allowInterop((response) {
    //   handlePaymentFailure(response, onFail);
    // })]);
    //
    //   js.context['Razorpay'].callMethod('on', ['payment.failed', js.allowInterop((response) {
    //     handlePaymentFailure(response, onFail);
    //   })]);
  }

  }




  Future<void> handleRefund({required BuildContext context,required String paymentId, required int refundAmount,required int orderAmount, required String orderId,}) async {

    // context.pop();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final url = 'https://us-central1-wander-crew.cloudfunctions.net/handlePayment';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'paymentId': paymentId, 'amount': refundAmount * 100}),
    );

    if (response.statusCode == 200) {

          await FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderId)
              .update({
            'isRefunded': refundAmount < orderAmount ? 'partial refund' : 'complete refund',
            'refundAmount': refundAmount,
          });
           var controller = Get.find<AdminOrderListController>();
          controller.fetchOrderData();



      final snackBar = SnackBar(
        content: const Text("Success: Refund processed successfully"),
        backgroundColor: Colors.green,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      context.pop();


    }

    else {
      context.pop();
      // Get.snackbar(
      //   "Error",
      //   "Refund failed: ${response.body}",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );


    }
  }


}

  void handlePaymentSuccess(BuildContext context,response, Function onSuccess) {
    onSuccess(context,response);
  }

  void handlePaymentDismiss(Function onDismiss) {
    onDismiss();
  }

void handlePaymentFailure(response, Function onFailure) {
  onFailure(response);
}


