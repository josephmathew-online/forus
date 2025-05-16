import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc/features/chat/presentation/cubits/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/chat/domain/users.dart';
import 'package:cc/features/chat/presentation/pages/chat_screen.dart'; // Custom search bar widget

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  AppUser? currentUser;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUsers();
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  String generateChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort(); // Sort alphabetically
    return "${sortedIds[0]}_${sortedIds[1]}"; // Combine IDs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        // ignore: deprecated_member_use
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.5)),
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: const Text(
            "community",
            style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'Poppins'),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SearchBar(
                elevation: WidgetStateProperty.all(0), // Removes shadow
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                leading: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Icon(
                      Icons.search,
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.5),
                      size: 30,
                    ),
                  ],
                ),
                hintText: " Search",
                hintStyle: WidgetStateProperty.all(
                  TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.5), // Adjust opacity
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              )),
          Divider(
            height: .1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: BlocBuilder<UserCubit, List<Users>>(
              builder: (context, users) {
                final filteredUsers = users.where((user) {
                  return user.name.toLowerCase().contains(searchQuery);
                }).toList();
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    if (currentUser?.uid != user.uid) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 35,
                          backgroundImage: user.profilePic.isNotEmpty
                              ? CachedNetworkImageProvider(user.profilePic)
                              : const CachedNetworkImageProvider(
                                  'https://www.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png'),
                        ),
                        title: Text(user.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          user.isOnline ? "Online" : "Offline",
                          style: TextStyle(
                              color:
                                  user.isOnline ? Colors.green : Colors.grey),
                        ),
                        onTap: () {
                          String chatId =
                              generateChatId(currentUser!.uid, user.uid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                profileImageUrl: user.profilePic.isNotEmpty
                                    ? user.profilePic
                                    : 'https://www.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png',
                                chatId: chatId,
                                currentUserId: currentUser!.uid,
                                receiverName: user.name,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox.shrink();
                    }
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
