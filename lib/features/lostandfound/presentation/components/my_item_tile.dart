import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc/features/chat/presentation/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/lostandfound/domain/entities/item.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_cubit.dart';
import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class MyItemTile extends StatefulWidget {
  final Item item;
  final void Function()? onClaimPressed;

  const MyItemTile({
    Key? key,
    required this.item,
    this.onClaimPressed,
  }) : super(key: key);

  @override
  State<MyItemTile> createState() => _MyItemTileState();
}

class _MyItemTileState extends State<MyItemTile> {
  late final ItemCubit itemCubit = context.read<ItemCubit>();
  late final ProfileCubit profileCubit = context.read<ProfileCubit>();
  bool isOwnItem = false;
  AppUser? currentUser;

  Future<void> openGmailApp() async {
    const String email = "yourmail@example.com";
    const String subject = "Report an Issue";
    const String body = "Describe your issue here...";

    try {
      final Uri emailUri = Uri.parse(
          "mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // If mailto fails, launch Gmail directly
        await launchUrl(
          Uri.parse(
              "googlegmail://co?to=$email&subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}"),
          mode: LaunchMode.externalApplication,
        );
      }
    } on PlatformException catch (e) {
      debugPrint("Error launching Gmail: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  String generateChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort(); // Sort alphabetically
    return "${sortedIds[0]}_${sortedIds[1]}"; // Combine IDs
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnItem = (widget.item.userId == currentUser?.uid);
  }

  Future<ProfileUser?> fetchItemUser() async {
    return await profileCubit.getUserProfile(widget.item.userId);
  }

  void showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 300,
                height: 300,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileUser?>(
      future: fetchItemUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("User not found"));
        }
        final itemUser = snapshot.data!;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8.0),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey,
            //     blurRadius: 6,
            //     spreadRadius: 3,
            //     offset: const Offset(3, 5), // More visible shadow
            //   ),
            // ],
            // gradient: LinearGradient(
            //   colors: [Colors.white, Colors.grey.shade100],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
          ),
          padding: const EdgeInsets.all(8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Lost at: ${widget.item.location}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "item holder: ${itemUser.name}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (!isOwnItem)
                            IconButton(
                              icon: const Icon(Icons.message, size: 18),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      profileImageUrl: itemUser
                                              .profileImageUrl.isNotEmpty
                                          ? itemUser.profileImageUrl
                                          : 'https://www.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png',
                                      chatId: generateChatId(
                                          currentUser!.uid, itemUser.uid),
                                      currentUserId: currentUser!.uid,
                                      receiverName: itemUser.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (isOwnItem)
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline,
                                  size: 18),
                              onPressed: widget.onClaimPressed,
                            ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, size: 18),
                            onPressed: () {
                              // showMenu(
                              //   context: context,
                              //   position: RelativeRect.fromLTRB(100, 50, 0, 0),
                              //   items: [
                              //     PopupMenuItem(
                              //       value: 'report',
                              //       child: Text("Report Issue"),
                              //     ),
                              //   ],
                              // ).then((value) {
                              //   if (value == 'report') {}
                              // });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onLongPress: () =>
                      showFullImage(context, widget.item.imageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.item.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
