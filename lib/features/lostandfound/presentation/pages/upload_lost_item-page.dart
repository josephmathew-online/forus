import 'dart:io';
import 'dart:typed_data';
import 'package:cc/features/auth/presentation/components/my_Text_Field.dart';
import 'package:cc/features/lostandfound/domain/entities/item.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_cubit.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadLostItemPage extends StatefulWidget {
  const UploadLostItemPage({super.key});

  @override
  State<UploadLostItemPage> createState() => _UploadLostItemPageState();
}

class _UploadLostItemPageState extends State<UploadLostItemPage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  final textController = TextEditingController();
  final locationController = TextEditingController();
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    textController.addListener(updatePreview);
    locationController.addListener(updatePreview);
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  void updatePreview() {
    setState(() {});
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

  void uploadLostItem() {
    if (imagePickedFile == null ||
        textController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Image, description, and location are required')));
      return;
    }

    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      itemName: textController.text,
      location: locationController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
    );

    final lostItemCubit = context.read<ItemCubit>();
    if (kIsWeb) {
      lostItemCubit.createItem(newItem, imageBytes: imagePickedFile?.bytes);
    } else {
      lostItemCubit.createItem(newItem, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.removeListener(updatePreview);
    locationController.removeListener(updatePreview);
    textController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemStates>(
      builder: (context, state) {
        if (state is ItemsLoading || state is ItemsUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is ItemsLoaded) {
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
        title: const Text("Report Lost Item"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              onPressed: uploadLostItem,
              child: const Text(
                "Submit",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image & Description Preview (Styled like MyItemTile)
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textController.text.isNotEmpty
                              ? textController.text
                              : "Item Description",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          locationController.text.isNotEmpty
                              ? "Lost at: ${locationController.text}"
                              : "Lost at: [Location]",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  buildImagePreview(),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Description Field
            MyTextField(
              controller: textController,
              hintText: "Description",
              obscureText: false,
            ),
            const SizedBox(height: 15),

            // Location Field
            MyTextField(
              controller: locationController,
              hintText: "Last Seen Location",
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: imagePickedFile == null
                ? const Center(
                    child: Icon(Icons.image, color: Colors.white, size: 40),
                  )
                : Image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    image: kIsWeb
                        ? MemoryImage(webImage!)
                        : FileImage(File(imagePickedFile!.path!))
                            as ImageProvider,
                  ),
          ),
        ),

        // Pencil Icon (Pick Image Button)
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
