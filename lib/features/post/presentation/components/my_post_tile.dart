import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/components/my_Text_Field.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/post/domain/entities/comment.dart';
import 'package:cc/features/post/domain/entities/post.dart';
import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/post/presentation/cubits/post_states.dart';
import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:cc/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const MyPostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late final PostCubit postCubit = context.read<PostCubit>();
  late final ProfileCubit profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  late Future<ProfileUser?> postUserFuture;
  TextEditingController commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    postUserFuture = fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser?.uid);
  }

  Future<ProfileUser?> fetchPostUser() async {
    return await profileCubit.getUserProfile(widget.post.userId);
  }

//delete dialouge
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
              widget.onDeletePressed?.call();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

//like post
  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser?.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser?.uid);
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

  ////
  ///
  ///
  ///

  ///
  ///
  ///
  ///
  ///
  final TextEditingController _commentTextController = TextEditingController();
  void showCommentsSheet() {
    final TextEditingController commentController =
        TextEditingController(); // ✅ Local controller

    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height *
                  0.7, // ✅ Prevents overflow
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// 🔼 TextField Moved ABOVE the comments
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: commentController,
                            hintText: 'Type your Comment....',
                            obscureText: false,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              final text = commentController.text;
                              addComment(text);
                              setState(() {
                                commentController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  /// 🔽 Comments Section
                  Expanded(
                    child: BlocBuilder<PostCubit, PostStates>(
                      builder: (context, state) {
                        if (state is PostsLoaded) {
                          final post = state.posts
                              .firstWhere((p) => p.id == widget.post.id);

                          return post.comments.isNotEmpty
                              ? ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  reverse: true,
                                  itemCount: post.comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = post.comments[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xFFD2DCEE),
                                        child: Text(comment.userName[0]),
                                      ),
                                      title: Text("${comment.userName} "),
                                      subtitle: Text(comment.text),
                                      trailing: Text(
                                          "${timeago.format(comment.timestamp, locale: 'en_short')}"),
                                    );
                                  },
                                )
                              : Center(child: Text("No comments yet."));
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {});
  }

  void addComment(String text) {
    if (text.isEmpty) return; // ✅ Prevent empty comments

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: text,
      timestamp: DateTime.now(),
    );

    postCubit.addComment(widget.post.id, newComment);

    Future.microtask(() {
      setState(() {});
      _commentTextController.clear(); // ✅ Clear safely after UI update
    });
  }

  @override
  void dispose() {
    _commentTextController.dispose(); // ✅ Dispose only global controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileUser?>(
      future: postUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("User not found"));
        }

        final postUser = snapshot.data!;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(uid: widget.post.userId),
                    )),
                child: _AvatarImage(
                  url: postUser.profileImageUrl.isNotEmpty
                      ? postUser.profileImageUrl
                      : null,
                  uid: widget.post.userId,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: postUser.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isOwnPost)
                          GestureDetector(
                            onTap: showOptions,
                            child: SizedBox(
                              height: 24, // Reduced height
                              child: Icon(Icons.more_vert,
                                  size: 20, // Reduced icon size
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                      ],
                    ),
                    if (widget.post.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(widget.post.text),
                      ),
                    if (widget.post.imageUrl.isNotEmpty)
                      GestureDetector(
                        onDoubleTap: () {
                          // Navigate to full-screen zoomable image on double-tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageZoomScreen(
                                  imageUrl: widget.post.imageUrl),
                            ),
                          );
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.post.imageUrl,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration:
                                  const Duration(milliseconds: 200),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    _ActionsRow(
                      post: widget.post,
                      onLike: toggleLikePost,
                      onComment: showCommentsSheet,
                      currentUser: currentUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String? url;
  final String uid;

  const _AvatarImage({this.url, required this.uid});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: url != null && url!.isNotEmpty
          ? CachedNetworkImageProvider(url!)
          : null, // No network image if URL is null or empty
      child: url == null || url!.isEmpty
          ? const Icon(Icons.person, size: 30, color: Colors.white)
          : null, // Show icon only when no image is available
    );
  }
}

// ignore: must_be_immutable
class _ActionsRow extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  AppUser? currentUser;

  _ActionsRow({
    required this.post,
    required this.onLike,
    required this.onComment,
    this.currentUser,
  });
  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp, locale: 'en_short');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: onLike,
          icon: Icon(post.likes.contains(currentUser!.uid)
              ? Icons.favorite
              : Icons.favorite_border),
          label:
              Text(post.likes.isNotEmpty ? post.likes.length.toString() : ''),
        ),
        TextButton.icon(
          onPressed: onComment,
          icon: const Icon(Icons.mode_comment_outlined),
          label: Text(
              post.comments.isNotEmpty ? post.comments.length.toString() : ''),
        ),
        Spacer(),
        Text(
          ' · ${_formatTimestamp(post.timestamp)} ago',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class ImageZoomScreen extends StatelessWidget {
  final String imageUrl;

  const ImageZoomScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 5.0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain, // Ensures full image is visible initially
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.broken_image, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
