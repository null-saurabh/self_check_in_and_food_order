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
    required BuildContext context,
    required String key,
    required int amount,
    required String number,
    required String name,
    required Function onSuccess,
    required Function onFail,
    required Function onDismiss})
  async {

    showDialog(
      context: context,
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

    context.pop();

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
        handlePaymentSuccess(response,onSuccess);
    }),
        'modal': {
          'ondismiss': js.allowInterop(() {
            handlePaymentDismiss(onDismiss);
          })
        }
    });

    final rzp = js.context.callMethod('Razorpay', [options]);

    rzp.callMethod('open');

    js.context['Razorpay'].callMethod('on', ['payment.failed', js.allowInterop((response) {
      handlePaymentFailure(response, onFail);
    })]);

  }

  }




  Future<void> handleRefund({required BuildContext context,required String paymentId, required int refundAmount,required int orderAmount, required String orderId,}) async {

    context.pop();


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
      body: jsonEncode({'paymentId': paymentId, 'amount': refundAmount}),
    );

    if (response.statusCode == 200) {

      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection("Orders")
      //     .where("orderId",
      //     isEqualTo: orderId) // Assuming 'id' is the custom field name in Firestore
      //     .get();
      //
      // if (querySnapshot.docs.isNotEmpty) {

        // String  = querySnapshot.docs.first.id;
        // DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        //     .collection("Orders")
        //     .doc(orderId)
        //     .get();
        //
        //
        // if (orderSnapshot.exists) {
        //
        //   String  = querySnapshot.docs.first.id;


          await FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderId)
              .update({
            'isRefunded': refundAmount < orderAmount ? 'partial refund' : 'complete refund',
            'refundAmount': refundAmount,
          });
           var controller = Get.find<AdminOrderListController>();
          controller.fetchOrderData();



      context.pop();
          final snackBar = SnackBar(
            content: Text("Success: Refund processed successfully"),
            backgroundColor: Colors.green,
          );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);



    }

    else {
      context.pop();



      final snackBar = SnackBar(
        content: Text("Refund failed: ${response.body}"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);



    }
  }


}

  void handlePaymentSuccess(response, Function onSuccess) {
    onSuccess(response);
  }

  void handlePaymentDismiss(Function onDismiss) {
    onDismiss();
  }

void handlePaymentFailure(response, Function onFailure) {
  onFailure(response);
}


