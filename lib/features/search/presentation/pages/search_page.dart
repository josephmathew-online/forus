import 'package:cc/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/search/presentation/cubits/search_cubit.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<SearchCubit>().searchUsers(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
        backgroundColor: Color(0xFFC4D1E9),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchCubit>().searchUsers("");
                        },
                      )
                    : Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, List<ProfileUser>>(
              builder: (context, users) {
                if (users.isEmpty) {
                  return Center(child: Text('No users found'));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.bio.isNotEmpty == true
                          ? user.bio
                          : 'No bio available'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                uid: user.uid,
                              ),
                            ));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
