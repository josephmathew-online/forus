import 'dart:typed_data';

import 'package:cc/features/post/domain/entities/comment.dart';
import 'package:cc/features/post/domain/entities/post.dart';
import 'package:cc/features/post/domain/repos/post_repo.dart';
import 'package:cc/features/post/presentation/cubits/post_states.dart';
import 'package:cc/features/storage/domain/storage_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostsInitial());

  // Create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);

      await postRepo
          .createPost(newPost); // Ensure Firestore updates before refetching

      fetchAllPosts();
    } catch (e, stackTrace) {
      debugPrint("Error creating post: $e\n$stackTrace");
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      debugPrint("Fetching all posts...");

      final posts = await postRepo.fetchAllPost();

      debugPrint("Fetched posts: ${posts.length}");
      emit(PostsLoaded(posts));
    } catch (e, stackTrace) {
      debugPrint("Error fetching posts: $e\n$stackTrace");
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      fetchAllPosts(); // Refresh posts after deletion
    } catch (e, stackTrace) {
      debugPrint("Error deleting post: $e\n$stackTrace");
      emit(PostsError("Failed to delete post: $e"));
    }
  }

//toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError('failed to add comment: $e'));
    }
  }

  //delete comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError('failed to delete comment $e'));
    }
  }
}
