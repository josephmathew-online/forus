import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final bool seen;
  Message(
      {required this.senderId,
      required this.text,
      required this.timestamp,
      required this.seen});

  //convert into json
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'seen': seen,
    };
  }

  //convert from json to post
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      text: json['text'],
      timestamp: json['timestamp'],
      seen: json['seen'],
    );
  }
}
