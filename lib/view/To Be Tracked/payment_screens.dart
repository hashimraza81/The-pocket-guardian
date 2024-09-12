import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gentech/provider/profile_Provider.dart';
import 'package:gentech/stripe/stripe_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../const/app_colors.dart';
import '../../utils/reused_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentScreen> {
  // ignore: unused_field
  final bool _loading = false;
  // ignore: unused_field
  final String _errorMessage = '';
  StripeServices stripeServices = StripeServices();
  Map<String, dynamic>? paymentIntent;
  bool? checkboxListTileValue;

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    String? collectionName;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot trackingUserDoc = await FirebaseFirestore.instance
        .collection('trackingUsers')
        .doc(userId)
        .get();

    if (trackingUserDoc.exists) {
      // Notification body for TrackingUser
      collectionName = 'trackingUsers';
    } else {
      // Check if the user is in the 'TrackedUser' collection
      DocumentSnapshot trackedUserDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(userId)
          .get();

      if (trackedUserDoc.exists) {
        collectionName = 'trackUsers';
      }
    }
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        await FirebaseFirestore.instance
            .collection(collectionName!) // Specify the correct collection name
            .doc(FirebaseAuth
                .instance.currentUser!.uid) // Get the current user's document
            .update({
          'subscribed': true,
        });
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  @override
  Widget build(BuildContext context) {
    final payment = Provider.of<UserProfileProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F4F8),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF0F1113),
            size: 30,
          ),
          onPressed: () async {
            // context.safePop();
            Navigator.pop(context);
          },
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
              child: Text(
                'Subscription / Payment',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF0F1113),
                  fontSize: 24,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
              child: Text(
                'Your Subscription',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF57636C),
                  fontSize: 14,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0x34111417),
                      offset: Offset(
                        0.0,
                        2,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          unselectedWidgetColor: const Color(0xFF95A1AC),
                        ),
                        child: CheckboxListTile(
                          value: checkboxListTileValue ??= true,
                          onChanged: (newValue) async {
                            setState(() => checkboxListTileValue = newValue!);
                          },
                          title: const Text(
                            'Monthly',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF57636C),
                              fontSize: 12,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: const Text(
                            '\$9.99/mo',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF0F1113),
                              fontSize: 24,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          tileColor: const Color(0xFFF1F4F8),
                          activeColor: const Color(0xFF4B39EF),
                          checkColor: Colors.white,
                          dense: false,
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 12, 0),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 24, 0),
                        child: Text(
                          'Gain unlimited access to all the content we have to offer! ',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: ReusedButton(
                          text: 'Pay',
                          onPressed: () {
                            makePayment();
                          },
                          colorbg: AppColors.secondary,
                          colortext: AppColors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
