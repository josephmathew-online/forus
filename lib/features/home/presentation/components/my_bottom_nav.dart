import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/post/presentation/pages/upload_page_post.dart';
import 'package:cc/features/profile/presentation/pages/profile_page.dart';
import 'package:cc/features/search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNav extends StatelessWidget {
  const MyBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return GNav(
      gap: 8, // Gap between icon and text
      tabs: [
        GButton(
          icon: Icons.home,
          iconSize: 28,
          onPressed: () {},
          text: 'Home',
          textStyle: TextStyle(fontSize: 18),
        ),
        GButton(
          icon: Icons.add,
          iconSize: 28,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadPagePost()),
            );
          },
          text: 'Upload',
          textStyle: TextStyle(fontSize: 18),
        ),
        GButton(
          icon: Icons.search,
          iconSize: 28,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserSearchScreen()));
          },
          text: 'Search',
          textStyle: TextStyle(fontSize: 18),
        ),
        GButton(
          icon: Icons.account_circle,
          iconSize: 28,
          onPressed: () {
            final user = context.read<AuthCubit>().currentUser;
            String? uid = user!.uid;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          uid: uid,
                        )));
          },
          text: 'Profile',
          textStyle: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
