import 'package:cc/features/chat/domain/message.dart';
import 'package:cc/features/chat/domain/message_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMessageRepo implements MessageRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}
