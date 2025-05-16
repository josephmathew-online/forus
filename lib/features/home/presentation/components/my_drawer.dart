import 'package:cc/features/aboutcreators/presentation/about_creators.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/events/presentation/pages/event_page.dart';
import 'package:cc/features/home/presentation/components/my_drawer_tile.dart';
import 'package:cc/features/lostandfound/presentation/pages/lost_found_page.dart';
import 'package:cc/features/profile/presentation/pages/profile_page.dart';
import 'package:cc/features/search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 150, child: Image.asset("lib/images/logo/forus.png")),
            MyDrawerTile(
                icon: Icons.home,
                title: 'HOME',
                onTap: () {
                  Navigator.of(context).pop();
                }),
            MyDrawerTile(
                icon: Icons.person,
                title: 'PROFILE',
                onTap: () {
                  Navigator.of(context).pop();
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                uid: uid,
                              )));
                }),
            MyDrawerTile(
                icon: Icons.travel_explore,
                title: 'LOST AND FOUND',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LostAndFoundPage()));
                }),
            MyDrawerTile(
                icon: Icons.construction,
                title: 'MEET THE CREATORS',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                }),
            MyDrawerTile(
                icon: Icons.event_sharp,
                title: 'EVENTS',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventPage()));
                }),
            MyDrawerTile(
                icon: Icons.person_search,
                title: 'SEARCH',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSearchScreen()));
                }),
            MyDrawerTile(
                icon: Icons.admin_panel_settings,
                title: 'ADMIN LOGIN',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSearchScreen()));
                }),
            const Spacer(),
            MyDrawerTile(
                icon: Icons.logout,
                title: 'LOGOUT',
                onTap: () {
                  context.read<AuthCubit>().logout();
                }),
          ]),
        ),
      ),
    );
  }
}
