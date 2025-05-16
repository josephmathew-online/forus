import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/auth/presentation/cubits/auth_states.dart';
import 'package:cc/features/auth/presentation/pages/auth_page.dart';
import 'package:cc/features/chat/presentation/cubits/oneline_status_cubit.dart';
import 'package:cc/features/chat/presentation/pages/user_list.dart';
import 'package:cc/features/home/presentation/components/my_bottom_nav.dart';
import 'package:cc/features/home/presentation/components/my_drawer.dart';
import 'package:cc/features/post/presentation/components/my_post_tile.dart';
import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/post/presentation/cubits/post_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostCubit postCubit;
  late final OnlineStatusCubit onlineStatusCubit;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>();
    onlineStatusCubit =
        context.read<OnlineStatusCubit>(); // Properly initialize cubit
    fetchAllPosts();
    onlineStatusCubit.goOnline();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
  }

  // ignore: unused_element
  void _logout() {
    context.read<AuthCubit>().logout();
  }

  @override
  void dispose() {
    onlineStatusCubit.goOffline(); // Set user offline when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text(
            'forus.',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          foregroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListScreen()),
                );
              },
              icon: const Icon(
                Icons.mark_chat_unread,
                color: Color.fromARGB(201, 0, 0, 0),
              ),
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: BlocBuilder<PostCubit, PostStates>(
          builder: (context, state) {
            if (state is PostsLoading || state is PostsUploading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostsLoaded) {
              final allPosts = state.posts;
              if (allPosts.isEmpty) {
                return const Center(child: Text('No posts available'));
              }
              return ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  return MyPostTile(
                    post: post,
                    onDeletePressed: () => deletePost(post.id),
                  );
                },
              );
            } else if (state is PostsError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
        bottomNavigationBar: const MyBottomNav(),
      ),
    );
  }
}
