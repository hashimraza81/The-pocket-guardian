import 'dart:convert';

import 'package:http/http.dart' as http;

class StripeServices {
  Future<String?> createCheckoutSession() async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/checkout/sessions'),
      headers: {
        'Authorization':
            'Bearer sk_test_51PjJcmH6pq5VX25CTBvxjpUuBCKUOliqTdjtQvd873dW3fENeJaB6DN4P4FaiQX4iBI6hEE9ZiwGD5oqi5n7Y0sZ00OWL9vetp',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'payment_method_types[]': 'card',
        'line_items[0][price]': 'price_1PjJw2H6pq5VX25C0ZL9ilZO',
        'mode': 'subscription',
        'success_url': 'https://sites.google.com/view/includepaymentsuccessful',
        'cancel_url': 'https://sites.google.com/view/includepaymentfailed',
        //'ui_mode': 'embedded',
        //'redirect_on_completion': 'never',
        'line_items[0][quantity]': '1',
        'allow_promotion_codes': 'false',
        'payment_method_collection': 'if_required',
        'billing_address_collection': 'auto'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if 'url' is present and not null
      if (responseData.containsKey('url') && responseData['url'] != null) {
        final String checkoutUrl = responseData['url'];

        print('Checkout Session created successfully');
        print('Checkout URL: $checkoutUrl');
        return checkoutUrl;
      } else {
        print('URL is null or not present in the response body');
      }
    } else {
      print('Failed to create Checkout Session');
      print(response.body);
    }

    // Return null if there is an issue
    return null;
  }

  // void stripePayment() async {
  //   final paymentResponse = await processStripePayment(
  //     context,
  //     amount: 10,
  //     currency: 'USD',
  //     customerEmail: currentUserEmail,
  //     allowGooglePay: false,
  //     allowApplePay: false,
  //   );
  //   if (paymentResponse.paymentId == null &&
  //       paymentResponse.errorMessage != null) {
  //     showSnackbar(
  //       context,
  //       'Error: ${paymentResponse.errorMessage}',
  //     );
  //   }
  //   _model.paymentId = paymentResponse.paymentId ?? '';
  //   setState(() {});
  // }

  // Future<void> checkSub() async {
  //   // If the email is not provided, return a custom response or error message.
  //   print(['App', FFAppState().email]);
  //   if (FFAppState().email.isEmpty) {
  //     print(['Email not provided 3 ' + FFAppState().email]);
  //     return;
  //   }
  //
  //   dynamic customerRes = await StripeAPIGroup.getCustomerCall.call(
  //     email: FFAppState().email,
  //   );
  //
  //   // Initialize sub as false
  //   FFAppState().sub = false;
  //
  //   if (customerRes != null && customerRes.jsonBody.isNotEmpty) {
  //     print(['customerRes', customerRes.jsonBody]);
  //     dynamic jsonResponse = customerRes.jsonBody;
  //     List<dynamic> customers = jsonResponse['data'];
  //
  //     for (var customer in customers) {
  //       String customerId = customer['id'];
  //       dynamic activeSub;
  //
  //       if (FFAppState().stripeSubId.isNotEmpty &&
  //           FFAppState().stripeSubId.contains('cus_')) {
  //         activeSub = await StripeAPIGroup.getSubscriptionCall.call(
  //           customer: FFAppState().stripeSubId,
  //         );
  //       } else if (customerId.contains('cus_')) {
  //         activeSub = await StripeAPIGroup.getSubscriptionCall.call(
  //           customer: customerId,
  //         );
  //       } else {
  //         // Break out of the loop if the customerId doesn't contain 'cus_'
  //         print('Customer ID does not contain "cus_". Skipping this customer.');
  //         continue;
  //       }
  //
  //       if (activeSub != null && activeSub.jsonBody.isNotEmpty) {
  //         dynamic subResponse = activeSub.jsonBody;
  //         List<dynamic> subscriptions = subResponse['data'];
  //
  //         for (var subscription in subscriptions) {
  //           String subStatus = subscription['status'];
  //           if (subStatus == 'active') {
  //             FFAppState().stripeSubId = subscription['id'];
  //             // Set sub as true if active subscription is found
  //             FFAppState().sub = true;
  //             print(['Sub', FFAppState().stripeSubId, FFAppState().sub]);
  //             return;
  //           }
  //         }
  //       }
  //     }
  //   }
  // }
}
