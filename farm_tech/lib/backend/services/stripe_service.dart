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
        ),
      );

      final paymentProcessed = await _processPayment();

      if (paymentProcessed == null) return null;
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
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance
          .confirmPaymentSheetPayment(); // if error in payment then this will throw exception
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
