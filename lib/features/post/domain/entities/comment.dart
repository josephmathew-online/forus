import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  // Convert Comment -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Convert JSON -> Comment
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert Firestore Document -> Comment
  factory Comment.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment.fromJson({...data, 'id': doc.id});
  }

  // CopyWith method for updating fields
  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? text,
    DateTime? timestamp,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
