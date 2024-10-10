import 'dart:js' as js;


class RazorpayService {
  void openCheckout({required int amount,required String number,required String key,required Function onSuccess,required Function onFail,required Function onDismiss}) {
    final options = js.JsObject.jsify({
      'key': key,
      'amount': amount, // Amount in paise
      'name': 'WanderCrew',
      'description': 'WanderCrew',
      'prefill': {
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

  void handlePaymentSuccess(response, Function onSuccess) {
    // Handle successful payment here
    // print('Payment successful: $response');
    onSuccess(response);
  }

  void handlePaymentDismiss(Function onDismiss) {
    // Handle payment dismissal here
    // print('Payment dismissed');
    onDismiss();
  }

void handlePaymentFailure(response, Function onFailure) {
  // Handle payment failure here
  // print('Payment failed: $response');
  onFailure(response);
}

