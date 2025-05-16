import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/profile/domain/entities/repos/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser(
            email: userData['email'],
            name: userData['name'],
            uid: uid,
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl']?.toString() ?? '',
          );
        }
      }
      return null;
    } catch (e, stackTrace) {
      print('Error fetching user profile: $e');
      print(stackTrace); // Include stack trace for better debugging
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(updatedProfile.uid)
          .update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
