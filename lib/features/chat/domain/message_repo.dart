import 'package:cc/features/chat/domain/message.dart';

abstract class MessageRepo {
  Future<void> sendMessage(String chatId, Message message);
  Stream<List<Message>> getMessages(String chatId);
}
