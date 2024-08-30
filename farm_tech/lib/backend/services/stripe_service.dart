import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:farm_tech/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future makePayment(int amount) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        amount,
        "usd",
      );

      if (paymentIntentClientSecret == null) return null;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: "Shahmir Ahmed",
            billingDetails: BillingDetails(
                address: Address(
                    country: 'US',
                    city: '',
                    line1: '',
                    line2: '',
                    postalCode: '',
                    state: ''))),
      );

      final paymentProcessed =
          await _processPayment(); // null returned from here means user has cancelled payment

      if (paymentProcessed == null) return 'payment_process_cancelled';

      // print('Payment success 3');

      return 'success';
    } catch (e) {
      print('Err in makePayment: $e');
      return null;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(
          amount,
        ),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        // print('Payment success 1');
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print('Err in _createPaymentIntent: $e');
    }
    return null;
  }

  Future _processPayment() async {
    try {
      // print('Before presenting payment sheet');
      await Stripe.instance.presentPaymentSheet();
      // print('After presenting payment sheet');

      // print('Before confirming payment');
      try {
        await Stripe.instance
            .confirmPaymentSheetPayment()
            .timeout(Duration(seconds: 5), onTimeout: () {
          throw Exception('Payment confirmation timed out');
        });
        print('After confirming payment');
      } catch (e) {
        print('Err in confirmPaymentSheetPayment (timeout): $e');
        // return null;
      }
      // print('After confirming payment');

      // print('Payment success 2');

      return 'success';
    } catch (e) {
      print('Err in _processPayment: $e');
      return null;
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
