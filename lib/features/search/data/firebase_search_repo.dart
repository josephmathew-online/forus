import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/search/domain/search_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSearchRepo implements SearchRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ProfileUser>> searchUsers(String query) {
    return _firestore
        .collection("users")
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProfileUser.fromJson(doc.data()))
            .toList());
  }

  @override
  Stream<List<ProfileUser>> getAllUsers() {
    return _firestore.collection("users").snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ProfileUser.fromJson(doc.data())).toList());
  }
}
