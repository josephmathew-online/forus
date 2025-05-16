import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveTokenToFirestore() async {
  String? token = await FirebaseMessaging.instance.getToken();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  if (token != null) {
    await FirebaseFirestore.instance.collection('usersToken').doc(userId).set({
      'fcmToken': token,
    });
  }
}

Future<void> removeToken() async {
  String? uid = FirebaseAuth.instance.currentUser?.uid; // Check if null
  if (uid == null) {
    print("❌ No user found, skipping token removal.");
    return; // Prevent null error
  }

  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'token': FieldValue.delete(),
  });

  print("✅ Token removed for user: $uid");
}
