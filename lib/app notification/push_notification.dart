// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:http/http.dart' as http;

// class PushNotification {
//   static Future<String> getAccessToken() async {
//     print('object');
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "gentech-4aa53",
//       "private_key_id": "363f00bc2dbfcf4b8f2819853973ca576f399991",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDV7Ax1B55xNLMg\nco+NW+E3qihJcBW33iOgaQZhnvlxdAU5OMw4GS4zZdTHApNyTmtUZWgnUKcRWkCc\n+wqpvFgxUtY8pDguKPaLQCPCh2tI8SmtVYR3xopXKum/VeGa8zoGF2b0hbijLuRM\nv/LTEfTWzjyXLC5kqkO5RUG+cDKpEOBetirfJFM4e1Ovc5OZoBfTplaTzK/cemqy\nXW5YAHYz6Xa0ZJ/FhokH8GlBoV9oYAt06G+Ih0qnBO40fy3DkhxrHjOmfTYqvqfV\nqd5X501dfEogQo+e+grDIs86TX/w8odrhskF1ipyHCfFj6WdGYimNLsJ4pJq6xmc\nGMPh1TUpAgMBAAECggEABydDDWDJWBDCkqmyCjCR2eorObVxTHo1p8YLTBVkUvpl\nuFGhZpjU9iwIDvWTl6Vuql5PuszUIVzqvzUX2LAvJMsX1eRJ6qU9BVAKQhWELWa/\nFYhACz9M3fhV46uMBUHv5UdADpowH+jQAo8CoDNABDTWStnT3VLiO95IggU/dG7H\n4Xedy/79p3WZaxHhlhyKp5dmrAZdmPOQQsCCzR8uCm0RYq4N5HkAkKn1AV6qdbKV\nXD+goa3SKUyWhSTeG0vioH8kgy+ubjN4bFU3GQ/TKm6Jo22YBif9OycH9iTwMBoY\n/4Z5/xC88ILPDDkFeLTF/VR7t3t5aCRIuUr0fekMWQKBgQDxPWxEI2qFEqYG4Bge\njC5VHyEzyfoD2qJ/MSCvjuIEZ/KZWe6KZM77JmMrRbOxjdNXQ6fL6F+xoFiAdSL3\nMH1A+hB756R+ze8Jxz23mirX052pl1g1LeTFfW4Bc3CnrtsIaRvWwUAlOmUiQav7\nba5/wddP7CdC69AF61p/obkq9QKBgQDjAr3tFipWxMnsxLEuYVxpJqRLctmMuN+p\n0WYmYo6+PWEDWQIT6hqM7VjymarDmOUCXHm3n6JyhYFnS6sItJu6oWIshaSaZ/p5\nV0yAqASB5BXfU63ZRgkEqDWFRcs5rVpcavhZLU/9PsDTv5LdUtfEQE0s+X8p7Uxj\nd07KuF2o5QKBgQCT17TWPW42h6tAY23kqrxqZl2Ow6V5XzBfCtihPsu9L4c5/Cd4\noTdIK8py5pCtq+FthYT8LjkXPtF+SEtZeloIzDf194yUOdjZAUYNk2nWQ1ZIbPwd\n+zZM4gXc1cagvUR27xOklWKebh8001J3EEz09vLhhDS7ipE+T3Jy7cXxUQKBgDZw\nHeORAS41msawlFyu9F4y6gs9y3W3j8tFb92cnOZ6CZ2n5pun9B3/fOkQeKbXL3PV\ngUrLeUVFRrbiqm04AnBK6yQKGGL+tE4M5UelAw+zBpu7kWEdLmRzggInrohyTc0D\nyfJ4r0nnlo4wzqNMjnl9ggRbAGephDwGDFsIw00RAoGBAMl0+hblMxWD3O7JuliT\nnD/nB1p+ZzsVwsQH8/QcaK+qDILajANwRUxH4nTpLt6U/2yJ+KOdpM1WN5lMmWw8\nS+GABXALzdMnCU9APy45tx0yrsx9D8Ixq/ZcCTufoBQu/1VZn294n8kROir5umzb\nq3LtPHfKlpMmW+dlZR4lzRPv\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "the-pocket-guardian@gentech-4aa53.iam.gserviceaccount.com",
//       "client_id": "112098810803809965222",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/the-pocket-guardian%40gentech-4aa53.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };
//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email"
//           "https://www.googleapis.com/auth/firebase.database"
//           "https://www.googleapis.com/auth/firebase.messaging"
//     ];

//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );

//     //get the acceess token

//     auth.AccessCredentials credentials =
//         await auth.obtainAccessCredentialsViaServiceAccount(
//             auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//             scopes,
//             client);

//     client.close();

//     return credentials.accessToken.data;
//   }

//   static sendNotificationToSelectedRole(
//       String deviceToken, BuildContext context, String tripId) async {
//     final String serviceKey = await getAccessToken();
//     String endpointFirebaseCloudMessaging =
//         'https://fcm.googleapis.com/v1/projects/gentech-4aa53/messages:send';

//     final Map<String, dynamic> message = {
//       'message': {
//         'token':
//             'dJKpQSLaTam-X_J9ulWNBJ:APA91bE019nkfbkS5OoNTMFZv4oQO4nMM9IYcdKRdJ7x4JMMfh1bUp5HS1MRK1wVgD2UJMtqOtI0S8Nqoc19pG7WRBWH2L0QIIug-wH7ytk2pKSRLc3Rr3CXJugQJHox3GZzD-285z3q',
//         'notification': {
//           'title': 'Notification',
//           'body': 'This is test notification',
//         },
//         'data': {
//           'tripID': tripId,
//         }
//       }
//     };

//     final http.Response response = await http.post(
//       Uri.parse(endpointFirebaseCloudMessaging),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $serviceKey'
//       },
//       body: jsonEncode(message),
//     );
//     if (response.statusCode == 200) {
//       print('Notification Sent Successfully ');
//     } else {
//       print('Failed to send FCM message:${response.statusCode}');
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class PushNotification {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "gentech-4aa53",
      "private_key_id": "363f00bc2dbfcf4b8f2819853973ca576f399991",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDV7Ax1B55xNLMg\nco+NW+E3qihJcBW33iOgaQZhnvlxdAU5OMw4GS4zZdTHApNyTmtUZWgnUKcRWkCc\n+wqpvFgxUtY8pDguKPaLQCPCh2tI8SmtVYR3xopXKum/VeGa8zoGF2b0hbijLuRM\nv/LTEfTWzjyXLC5kqkO5RUG+cDKpEOBetirfJFM4e1Ovc5OZoBfTplaTzK/cemqy\nXW5YAHYz6Xa0ZJ/FhokH8GlBoV9oYAt06G+Ih0qnBO40fy3DkhxrHjOmfTYqvqfV\nqd5X501dfEogQo+e+grDIs86TX/w8odrhskF1ipyHCfFj6WdGYimNLsJ4pJq6xmc\nGMPh1TUpAgMBAAECggEABydDDWDJWBDCkqmyCjCR2eorObVxTHo1p8YLTBVkUvpl\nuFGhZpjU9iwIDvWTl6Vuql5PuszUIVzqvzUX2LAvJMsX1eRJ6qU9BVAKQhWELWa/\nFYhACz9M3fhV46uMBUHv5UdADpowH+jQAo8CoDNABDTWStnT3VLiO95IggU/dG7H\n4Xedy/79p3WZaxHhlhyKp5dmrAZdmPOQQsCCzR8uCm0RYq4N5HkAkKn1AV6qdbKV\nXD+goa3SKUyWhSTeG0vioH8kgy+ubjN4bFU3GQ/TKm6Jo22YBif9OycH9iTwMBoY\n/4Z5/xC88ILPDDkFeLTF/VR7t3t5aCRIuUr0fekMWQKBgQDxPWxEI2qFEqYG4Bge\njC5VHyEzyfoD2qJ/MSCvjuIEZ/KZWe6KZM77JmMrRbOxjdNXQ6fL6F+xoFiAdSL3\nMH1A+hB756R+ze8Jxz23mirX052pl1g1LeTFfW4Bc3CnrtsIaRvWwUAlOmUiQav7\nba5/wddP7CdC69AF61p/obkq9QKBgQDjAr3tFipWxMnsxLEuYVxpJqRLctmMuN+p\n0WYmYo6+PWEDWQIT6hqM7VjymarDmOUCXHm3n6JyhYFnS6sItJu6oWIshaSaZ/p5\nV0yAqASB5BXfU63ZRgkEqDWFRcs5rVpcavhZLU/9PsDTv5LdUtfEQE0s+X8p7Uxj\nd07KuF2o5QKBgQCT17TWPW42h6tAY23kqrxqZl2Ow6V5XzBfCtihPsu9L4c5/Cd4\noTdIK8py5pCtq+FthYT8LjkXPtF+SEtZeloIzDf194yUOdjZAUYNk2nWQ1ZIbPwd\n+zZM4gXc1cagvUR27xOklWKebh8001J3EEz09vLhhDS7ipE+T3Jy7cXxUQKBgDZw\nHeORAS41msawlFyu9F4y6gs9y3W3j8tFb92cnOZ6CZ2n5pun9B3/fOkQeKbXL3PV\ngUrLeUVFRrbiqm04AnBK6yQKGGL+tE4M5UelAw+zBpu7kWEdLmRzggInrohyTc0D\nyfJ4r0nnlo4wzqNMjnl9ggRbAGephDwGDFsIw00RAoGBAMl0+hblMxWD3O7JuliT\nnD/nB1p+ZzsVwsQH8/QcaK+qDILajANwRUxH4nTpLt6U/2yJ+KOdpM1WN5lMmWw8\nS+GABXALzdMnCU9APy45tx0yrsx9D8Ixq/ZcCTufoBQu/1VZn294n8kROir5umzb\nq3LtPHfKlpMmW+dlZR4lzRPv\n-----END PRIVATE KEY-----\n",
      "client_email":
          "the-pocket-guardian@gentech-4aa53.iam.gserviceaccount.com",
      "client_id": "112098810803809965222",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/the-pocket-guardian%40gentech-4aa53.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    try {
      // Get the access token
      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      print('Access Token: ${credentials.accessToken.data}');

      return credentials.accessToken.data;
    } catch (e) {
      print('Error obtaining access token: $e');
      rethrow;
    } finally {
      client.close();
    }
  }

  static sendNotificationToSelectedRole(
      String deviceToken, BuildContext context, String tripId) async {
    final String serviceKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/gentech-4aa53/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': 'Notification',
          'body': 'This is test notification',
        },
        'data': {
          'tripID': tripId,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serviceKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification Sent Successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
