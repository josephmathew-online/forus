import 'package:cc/features/chat/domain/message.dart';
import 'package:cc/features/chat/domain/message_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<List<Message>> {
  final MessageRepo messageRepo;

  ChatCubit(this.messageRepo, String chatId) : super([]) {
    _listenForMessages(chatId); // ✅ Auto-load messages on initialization
  }

  // ✅ Sends a message
  void sendMessage(String chatId, Message message) async {
    await messageRepo.sendMessage(chatId, message);
  }

  // 🔥 Real-time updates from Firestore
  void _listenForMessages(String chatId) {
    messageRepo.getMessages(chatId).listen((messages) {
      emit(messages); // ✅ Updates UI in real-time
    });
  }
}
