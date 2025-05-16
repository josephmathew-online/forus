import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDoc {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String reportedId;
  final DateTime timestamp;

  ReportDoc({
    required this.id,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.text,
    required this.reportedId,
  });

  ReportDoc copyWith({String? userId}) {
    return ReportDoc(
      id: id,
      userId: this.userId,
      userName: userName,
      text: text,
      timestamp: timestamp,
      reportedId: reportedId,
    );
  }

  // Convert item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'reportedId': reportedId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create item from JSON
  factory ReportDoc.fromJson(Map<String, dynamic> json) {
    return ReportDoc(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      text: json['text'],
      reportedId: json['reportedId'],
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
