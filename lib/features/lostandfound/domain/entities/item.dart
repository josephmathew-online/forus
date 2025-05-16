import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String userId;
  final String userName;
  final String itemName;
  final String location;
  final String imageUrl;
  final DateTime timestamp;

  Item({
    required this.id,
    required this.userId,
    required this.userName,
    required this.itemName,
    required this.location,
    required this.imageUrl,
    required this.timestamp,
  });

  Item copyWith({String? imageUrl}) {
    return Item(
      id: id,
      userId: userId,
      userName: userName,
      itemName: itemName,
      location: location,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
    );
  }

  // Convert item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'itemName': itemName,
      'location': location,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create item from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      itemName: json['itemName'] ?? 'Unknown Item', // Default value
      location: json['location'] ?? 'Unknown Location', // Default value
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
