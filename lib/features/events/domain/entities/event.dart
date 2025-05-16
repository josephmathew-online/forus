class Event {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dateTime;

  Event({
    required this.userId,
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
