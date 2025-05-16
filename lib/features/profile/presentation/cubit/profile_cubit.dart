import 'dart:typed_data';

import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/profile/domain/entities/repos/profile_repo.dart';
import 'package:cc/features/profile/presentation/cubit/profile_state.dart';
import 'package:cc/features/storage/domain/storage_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());
  //fetch usr profile suing repo -> usefull for loading profile pages
  Future<void> fetchUserProfile(String uid) async {
    emit(ProfileLoading()); // Start loading state
    try {
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user)); // Successfully loaded profile
      } else {
        emit(ProfileError('User profile not found'));
      }
    } catch (e) {
      emit(ProfileError('Error fetching user profile: $e'));
    }
  }

// Fetch user profile for general usage (e.g., in posts)
  Future<ProfileUser?> getUserProfile(String uid) async {
    return await profileRepo.fetchUserProfile(uid);
  }

  //update bio or profile pic

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      //fetch current profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError('failed to fetch user for profile update'));
        return;
      }

      //profile pic update
      String? imageDownloadUrl;
      if (imageWebBytes != null || imageMobilePath != null) {
        //for mobile
        if (imageMobilePath != null) {
          //upload
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }
        //for web
        else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }
        if (imageDownloadUrl == null) {
          emit(ProfileError('failed to upload image'));
          return;
        }
      }

      //update new profile
      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      await profileRepo.updateProfile(updateProfile);

      //refetch updated one

      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error in updating : $e'));
    }
  }
}
