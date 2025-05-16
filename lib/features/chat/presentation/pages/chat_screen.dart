import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/chat/data/firebase_message_repo.dart';
import 'package:cc/features/chat/domain/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../cubits/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String currentUserId;
  final String receiverName;
  final String profileImageUrl;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receiverName,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    AppUser? currentUser = authCubit.currentUser;

    return BlocProvider(
      create: (context) => ChatCubit(FirebaseMessageRepo(), chatId),
      child: ChatView(
        profileImageUrl: profileImageUrl,
        chatId: chatId,
        currentUserId: currentUser!.uid,
        receiverName: receiverName, // ✅ Pass receiver name
      ),
    );
  }
}

class ChatView extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String receiverName;
  final String profileImageUrl;

  const ChatView({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receiverName,
    required this.profileImageUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false; // Track user input

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.trim().isNotEmpty;
    });
  }

  // Method to format the timestamp
  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('hh:mm a')
        .format(timestamp.toDate()); // Format timestamp as "5:30 PM"
  }

  Widget _buildMessage(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isMe
            ? EdgeInsets.only(top: 8.0, bottom: 5.0, left: 110.0, right: 10.0)
            : EdgeInsets.only(top: 8.0, bottom: 5.0, right: 110.0, left: 10.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? Color(0xFFC4D1E9) : Color(0xFFD2DDEE),
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0))
              : BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 1.0,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.text,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 3.0),
            Text(
              _formatTimestamp(
                  message.timestamp), // Use the formatted timestamp here
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 22.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5.0),
                  IconButton(
                    icon: Icon(Icons.gif_box_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 22.0),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 150),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          scrollController: _scrollController,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10.0),
                          ),
                          onChanged: _onTextChanged,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 22.0),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {},
                  ),
                  if (!_isTyping)
                    IconButton(
                      icon: Icon(Icons.camera_alt_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 22.0),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {},
                    ),
                  SizedBox(width: 5.0),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            height: 48.0,
            width: 45.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _isTyping ? Icons.send : Icons.mic,
                color: Colors.white,
                size: 22.0,
              ),
              onPressed: () {
                if (_isTyping) {
                  context.read<ChatCubit>().sendMessage(
                        widget.chatId,
                        Message(
                          senderId: widget.currentUserId,
                          text: _controller.text,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          seen: false,
                        ),
                      );
                  _controller.clear();
                  setState(() => _isTyping = false);
                } else {}
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.0,
              backgroundImage: widget.profileImageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(widget.profileImageUrl)
                  : const AssetImage("assets/default_avatar.png")
                      as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              widget.receiverName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, List<Message>>(
              builder: (context, messages) {
                if (messages.isEmpty) {
                  return Center(child: Text("No new messages."));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == widget.currentUserId;

                    return _buildMessage(message, isMe);
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }
}
