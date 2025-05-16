import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseApi {
  //create an instance of Firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to initialise notifications
  Future<void> initNotification() async {
    // request permission from user (will prompt)
    await _firebaseMessaging.requestPermission();

    //fetch the fcm token for the message
    final fCMToken = await _firebaseMessaging.getToken();

    //print the token (normaly you would send this to your server)
    if (kDebugMode) {
      print('Token : $fCMToken');
    }
    initPushNotifications();
  }

  //functions to handle received messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
  }

  //function to initialise background settings
  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    //handle notification is the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listensers for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("all_users");
  }
}
