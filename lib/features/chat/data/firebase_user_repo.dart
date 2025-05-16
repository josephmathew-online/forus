import 'package:cc/features/chat/domain/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Users>> getUsers() {
    return firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Users.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }
}
