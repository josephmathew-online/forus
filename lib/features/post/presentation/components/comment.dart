import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/post/presentation/cubits/post_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            final post = state.posts.firstWhere((post) => post.id == post.id);
            if (post.comments.isNotEmpty) {
              return Column(
                children: [
                  Text("Comments (${post.comments.length})"),
                  // Wrap ListView with Flexible to avoid layout issues
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: post.comments.length,
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                comment.userName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: Text(comment.text)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Text("No comments yet.");
            }
          }

          if (state is PostsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}
