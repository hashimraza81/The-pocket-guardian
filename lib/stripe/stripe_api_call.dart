// import 'dart:convert';
//
// class StripeAPIGroup {
//   static String baseUrl = 'https://api.stripe.com/v1/';
//   static Map<String, String> headers = {};
//   static GetCustomerCall getCustomerCall = GetCustomerCall();
//   static GetSubscriptionCall getSubscriptionCall = GetSubscriptionCall();
// }
//
// class GetCustomerCall {
//   Future<ApiCallResponse> call({
//     String? email = '',
//     String? key =
//     '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',
//   }) async {
//     return ApiManager.instance.makeApiCall(
//       callName: 'Get Customer',
//       apiUrl: '${StripeAPIGroup.baseUrl}customers',
//       callType: ApiCallType.GET,
//       headers: {
//         'Authorization':
//         'Bearer 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',
//       },
//       params: {
//         'email': email,
//       },
//       returnBody: true,
//       encodeBodyUtf8: false,
//       decodeUtf8: false,
//       cache: false,
//       alwaysAllowBody: false,
//     );
//   }
// }
//
// class GetSubscriptionCall {
//   Future<ApiCallResponse> call({
//     String? customer = '',
//     String? key =
//     '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',
//     String? status = 'active',
//   }) async {
//     return ApiManager.instance.makeApiCall(
//       callName: 'Get Subscription',
//       apiUrl: '${StripeAPIGroup.baseUrl}subscriptions',
//       callType: ApiCallType.GET,
//       headers: {
//         'Authorization':
//         'Bearer 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',
//       },
//       params: {
//         'customer': customer,
//         'status': status,
//       },
//       returnBody: true,
//       encodeBodyUtf8: false,
//       decodeUtf8: false,
//       cache: false,
//       alwaysAllowBody: false,
//     );
//   }
// }
//
// /// End Stripe API Group Code
//
// class CreatePaymentLinkCall {
//   static Future<ApiCallResponse> call({
//     String? key =
//     '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',
//     String? mode = 'subscription',
//     String? priceID = 'price_1OHDZADwxd7zcc7RJ0t7Bdzv',
//     List<bool>? promotionCodeList,
//     String? successUrl =
//     'https://sites.google.com/view/includepaymentsuccessful',
//     String? cancelUrl = 'https://sites.google.com/view/includepaymentfailed',
//   }) async {
//     final promotionCode = _serializeList(promotionCodeList);
//
//     return ApiManager.instance.makeApiCall(
//       callName: 'Create Payment Link',
//       apiUrl: 'https://api.stripe.com/v1/checkout/sessions',
//       callType: ApiCallType.POST,
//       headers: {
//         'Authorization':
//         'Bearer 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',
//       },
//       params: {
//         'payment_method_types[]': "card",
//         'line_items[][price]': priceID,
//         'mode': mode,
//         'line_items[][quantity]': 1,
//         'allow_promotion_codes': true,
//         'payment_method_collection': "if_required",
//         'billing_address_collection': "auto",
//         'success_url': successUrl,
//         'cancel_url': cancelUrl,
//       },
//       bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
//       returnBody: true,
//       encodeBodyUtf8: false,
//       decodeUtf8: false,
//       cache: false,
//       alwaysAllowBody: false,
//     );
//   }
//
//   static String? url(dynamic response) => castToType<String>(getJsonField(
//     response,
//     r'''$.url''',
//   ));
//   static String? id(dynamic response) => castToType<String>(getJsonField(
//     response,
//     r'''$.id''',
//   ));
// }
//
// class PaymentLinkCall {
//   static Future<ApiCallResponse> call({
//     String? priceID = 'price_1OHDZADwxd7zcc7RJ0t7Bdzv',
//     String? key =
//     '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',
//     String? mode = 'subscription',
//     List<bool>? promotionCodeList,
//     String? successUrl = 'https://include.page.link',
//     String? cancelUrl = '',
//     String? url = 'https://buy.stripe.com/eVaeVW9nY1kD9qM7ss',
//   }) async {
//     final promotionCode = _serializeList(promotionCodeList);
//
//     return ApiManager.instance.makeApiCall(
//       callName: 'Payment Link',
//       apiUrl: 'https://api.stripe.com/v1/checkout/sessions',
//       callType: ApiCallType.POST,
//       headers: {
//         'Authorization':
//         'Bearer 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',
//       },
//       params: {
//         'line_items[][quantity]': 1,
//         'allow_promotion_codes': true,
//         'mode': mode,
//         'payment_method_collection': "if_required",
//         'billing_address_collection': "auto",
//         'payment_method_types[]': "card",
//         'ui_mode': "embedded",
//         'redirect_on_completion': "if_required",
//         'line_items[][price]': priceID,
//       },
//       bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
//       returnBody: true,
//       encodeBodyUtf8: false,
//       decodeUtf8: false,
//       cache: false,
//       alwaysAllowBody: false,
//     );
//   }
// }
//
// class ApiPagingParams {
//   int nextPageNumber = 0;
//   int numItems = 0;
//   dynamic lastResponse;
//
//   ApiPagingParams({
//     required this.nextPageNumber,
//     required this.numItems,
//     required this.lastResponse,
//   });
//
//   @override
//   String toString() =>
//       'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
// }
//
// String _serializeList(List? list) {
//   list ??= <String>[];
//   try {
//     return json.encode(list);
//   } catch (_) {
//     return '[]';
//   }
// }
//
// String _serializeJson(dynamic jsonVar, [bool isList = false]) {
//   jsonVar ??= (isList ? [] : {});
//   try {
//     return json.encode(jsonVar);
//   } catch (_) {
//     return isList ? '[]' : '{}';
//   }
// }
