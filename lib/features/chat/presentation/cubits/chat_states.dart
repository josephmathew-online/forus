import 'package:cc/features/chat/domain/message.dart';

abstract class ChatStates {}

// ignore: camel_case_types
class messageInitial extends ChatStates {}

// ignore: camel_case_types
class messageLoading extends ChatStates {}

// ignore: camel_case_types
class messageLoaded extends ChatStates {
  final List<Message> message;
  messageLoaded(this.message);
}

// ignore: camel_case_types
class messageError extends ChatStates {
  final String message;
  messageError(this.message);
}
