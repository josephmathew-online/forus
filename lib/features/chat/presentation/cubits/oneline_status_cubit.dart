import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnlineStatusCubit extends Cubit<bool> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;

  OnlineStatusCubit() : super(false) {
    _init();
  }

  void _init() {
    final user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      _updateStatus(true);
    }
  }

  void _updateStatus(bool isOnline) {
    if (_userId != null) {
      _firestore
          .collection('users')
          .doc(_userId)
          .update({'isOnline': isOnline});
      emit(isOnline);
    }
  }

  void goOnline() => _updateStatus(true);
  void goOffline() => _updateStatus(false);

  @override
  Future<void> close() {
    goOffline();
    return super.close();
  }
}
