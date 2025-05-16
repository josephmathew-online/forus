import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:flutter/material.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  ProfileUser(
      {required super.email,
      required super.name,
      required super.uid,
      required this.bio,
      required this.profileImageUrl});

  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
        email: email,
        name: name,
        uid: uid,
        bio: newBio ?? bio,
        profileImageUrl: newProfileImageUrl ?? profileImageUrl);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    final profileImageUrl = json['profileImageUrl'] ?? '';
    final bio = json['bio'] ?? '';

    // Optionally log if these fields are empty
    if (profileImageUrl.isEmpty) {
      debugPrint('Profile image URL is missing for UID: ${json['uid']}');
    }
    if (bio.isEmpty) {
      debugPrint('Bio is missing for UID: ${json['uid']}');
    }

    return ProfileUser(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      bio: bio,
      profileImageUrl: profileImageUrl,
    );
  }
}
