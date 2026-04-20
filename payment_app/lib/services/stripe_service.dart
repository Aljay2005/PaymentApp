import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/stripe_config.dart';

class StripeService {
  static const Map<String, String> _testTokens = {
    '4224242424242': 'tok_visa',
    '4000000086794': 'tok_visa_debit',
    '5986958746364': 'tok_mastercard',
    '1231123144342': 'tok_mastercard_debit',
    '6456546654766': 'tok_chargeDeclined', // Fixed typo: 'charged' to 'charge'
    '8908098809098': 'tok_chargeDeclinedInsufficientFunds',
  };

  static Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
  }) async {
    // Rounding to int first is safer for currency math
    final amountInCents = (amount * 100).toInt().toString();
    final cleanCard = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    final token = _testTokens[cleanCard];

    if (token == null) {
      return <String, dynamic>{
        'success': false,
        'error': 'Unknown test card number.',
      };
    }

    try {
      final response = await http.post(
        Uri.parse('${StripeConfig.apiUrl}/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents,
          'currency': 'php',
          'payment_method_data[type]': 'card', // Fixed 'types' to 'type'
          'payment_method_data[card][token]': token,
          'confirm': 'true',
          // Required for confirm: true in many Stripe API versions
          'return_url': 'https://your-website.com/payment-complete',
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['status'] == 'succeeded') {
        return <String, dynamic>{
          'success': true,
          'id': data['id'],
          'amount': (data['amount'] as num) / 100,
          'status': data['status'],
        };
      } else {
        // Safely extract the error message from Stripe's response
        final String errorMsg = data['error'] != null
            ? data['error']['message']
            : 'Payment failed';

        return {
          'success': false,
          'error': errorMsg
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection error: ${e.toString()}'
      };
    }
  }
}