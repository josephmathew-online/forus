class Users {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final bool isOnline;

  Users({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.isOnline,
  });
  factory Users.fromJson(Map<String, dynamic> map, String uid) {
    return Users(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profileImageUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
    );
  }
}
