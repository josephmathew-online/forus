import 'dart:io';
import 'dart:typed_data';
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/post/domain/entities/post.dart';
import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/post/presentation/cubits/post_states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPagePost extends StatefulWidget {
  const UploadPagePost({super.key});

  @override
  State<UploadPagePost> createState() => _UploadPagePostState();
}

class _UploadPagePostState extends State<UploadPagePost> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;

  final textController = TextEditingController();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  void uploadPost() {
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both image and caption are required')),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    final postCubit = context.read<PostCubit>();
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        if (state is PostsLoading || state is PostsUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4D1E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              onPressed: uploadPost,
              child: const Text(
                "Upload",
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            buildPostPreview(),
          ],
        ),
      ),
    );
  }

  Widget buildPostPreview() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 300, // Fixed height for the preview
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.name ?? "User",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),

                      // Caption TextField inside preview
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 20,
                        child: TextField(
                          controller: textController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 14),
                            hintText: "tap here to caption...",
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: TextStyle(fontSize: 14),
                          showCursor: false,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Image preview
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imagePickedFile != null
                      ? (kIsWeb
                          ? Image.memory(webImage!,
                              width: double.infinity, fit: BoxFit.cover)
                          : Image.file(File(imagePickedFile!.path!),
                              width: double.infinity, fit: BoxFit.cover))
                      : Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text("No Image Selected",
                              style: TextStyle(color: Colors.grey)),
                        ),
                ),
              ),
            ],
          ),
        ),

        // Floating pencil icon for picking image
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            onPressed: pickImage,
            backgroundColor: Colors.blueAccent,
            mini: true,
            shape: const CircleBorder(),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
