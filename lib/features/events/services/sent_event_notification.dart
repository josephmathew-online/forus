import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

Future<void> sendPushNotification(
    String token, String title, String body) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=YOUR_SERVER_KEY', // Replace with your FCM Server Key
      },
      body: jsonEncode({
        'to': token,
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
        },
      }),
    );
    // ignore: empty_catches
  } catch (e) {}
}
