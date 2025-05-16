import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/chat/presentation/pages/chat_screen.dart';
import 'package:cc/features/post/presentation/components/my_post_tile.dart';
import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/post/presentation/cubits/post_states.dart';
import 'package:cc/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:cc/features/profile/presentation/cubit/profile_state.dart';
import 'package:cc/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthCubit authCubit;
  late final ProfileCubit profileCubit;
  String generateChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort(); // Sort alphabetically
    return "${sortedIds[0]}_${sortedIds[1]}"; // Combine IDs
  }

  //current user

  late AppUser? currentUser = authCubit.currentUser;
  //post
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    profileCubit = context.read<ProfileCubit>();

    // Load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        final user = state.profileUser;
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              title: Text(
                'Profile',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              centerTitle: true,
              elevation: 0,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(4), // Border thickness
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF344CB7), width: 2),
                  ),
                  //avathar
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF344CB7), // Rich Blue
                    radius: 50,
                    child: CachedNetworkImage(
                      imageUrl: user.profileImageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //email icons also
                // User Email
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: Color(0xFFC4D1E9)),
                    SizedBox(width: 5),
                    Text(user.email, style: TextStyle(color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                if (user.uid == currentUser!.uid)
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC4D1E9), // Rich Blue Button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                      user: user,
                                    )));
                      },
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                      ),
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC4D1E9), // Rich Blue Button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              profileImageUrl: user.profileImageUrl.isNotEmpty
                                  ? user.profileImageUrl
                                  : 'https://www.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png',
                              chatId:
                                  generateChatId(currentUser!.uid, user.uid),
                              currentUserId: currentUser!.uid,
                              receiverName: user.name,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Chat',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                      ),
                    ),
                  ),

                // Profile Image (Only use imageBuilder for the image display)
                const SizedBox(height: 25),

                // Posts Section
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),

                //list of post from this user
                BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
                  //post loaded
                  if (state is PostsLoaded) {
                    //filter posts by user Id
                    final userPosts = state.posts
                        .where((post) => post.userId == widget.uid)
                        .toList();
                    postCount = userPosts.length;
                    return ListView.builder(
                      itemCount: postCount,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        //get individual post
                        final post = userPosts[index];

                        //return as post title UI
                        return MyPostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id));
                      },
                    );
                  } else if (state is PostsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(
                      child: Text("No posts.."),
                    );
                  }
                })
              ],
            ));
      } else if (state is ProfileLoading) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('No profile found'),
          ),
        );
      }
    });
  }
}
