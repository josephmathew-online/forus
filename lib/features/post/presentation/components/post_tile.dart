import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/components/my_Text_Field.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/post/domain/entities/comment.dart';
import 'package:cc/features/post/domain/entities/post.dart';
import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:cc/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null && mounted) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  final commentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new comment'),
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type Comment",
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Explicit background color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 3,
            offset: const Offset(3, 5), // More visible shadow
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile and Post Info
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: widget.post.userId),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Pic
                  postUser?.profileImageUrl != null &&
                          postUser!.profileImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        )
                      : const Icon(Icons.person, size: 40, color: Colors.grey),
                  // Name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Delete Button (If Own Post)
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: Icon(Icons.more_vert,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                ],
              ),
            ),
          ),
          // Post Image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          // Post Text
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.post.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // Like, Comment, and Timestamp Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(widget.post.likes.contains(currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border),
                      ),
                      Text(widget.post.likes.length.toString()),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: const Icon(Icons.comment),
                ),
                Text(widget.post.comments.length.toString()),
                const Spacer(),
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
