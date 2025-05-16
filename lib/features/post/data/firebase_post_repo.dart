import 'package:cc/features/post/domain/entities/comment.dart';
import 'package:cc/features/post/domain/entities/post.dart';
import 'package:cc/features/post/domain/repos/post_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //store the post in the collection called  "post"
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('post');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("error in creating post : $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPost() async {
    try {
      debugPrint("Fetching posts from Firestore...");

      final postsSnapShot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      // Debug: Print raw Firestore data
      for (var doc in postsSnapShot.docs) {
        debugPrint("Document ID: ${doc.id}");
        debugPrint("Document Data: ${doc.data()}");
      }

      final List<Post> allPost = postsSnapShot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      debugPrint("Successfully fetched ${allPost.length} posts");
      return allPost;
    } catch (e, stackTrace) {
      debugPrint("Error in fetchAllPost: $e\n$stackTrace");
      throw Exception("Error in fetching post: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      //fetch post snapshot with this uid
      final postsSnapShot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      // convert firestore documents from json to List of post
      final userPosts = postsSnapShot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts by user: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //get the post document from firestore
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //check if user has already liked
        final hasLiked = post.likes.contains(userId);
        if (hasLiked) {
          post.likes.remove(userId); //unlike
        } else {
          post.likes.add(userId); //like
        }

        //update the post document with the new like list
        await postsCollection.doc(postId).update({
          'likes': post.likes,
        });
      } else {
        throw Exception('post not found');
      }
    } catch (e) {
      throw Exception('error toggling like:$e');
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        //convert json object -> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the new comment
        post.comments.add(comment);

        //update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("post not found");
      }
    } catch (e) {
      throw Exception("error adding comments : $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        //convert json object -> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("post not found");
      }
    } catch (e) {
      throw Exception("error deleting comments : $e");
    }
  }
}
