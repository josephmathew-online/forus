import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:cc/features/profile/presentation/cubit/profile_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  //web image pick
  Uint8List? webImage;

  // bio text controller
  final bioTextController = TextEditingController();

  //pick image
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

//update profile button pressed
  void updateProfile() async {
    //profle cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepareimage & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final ImageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    //only update profle is there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: ImageWebBytes,
      );
      //nothing to upload
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, State) {
      //profile loading..
      if (State is ProfileLoading) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 240, 220),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Uploading...'),
              ],
            ),
          ),
        );
      } else {
        return buildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black, // Black text color
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4), // Border thickness
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF344CB7), width: 2),
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF344CB7), // Rich Blue
                        radius: 50,
                        backgroundImage: (!kIsWeb && imagePickedFile != null)
                            ? FileImage(File(imagePickedFile!.path!))
                                as ImageProvider
                            : (kIsWeb && webImage != null)
                                ? MemoryImage(webImage!)
                                : null, // No default image here, handled below
                        child: (!kIsWeb &&
                                imagePickedFile == null &&
                                webImage == null)
                            ? CachedNetworkImage(
                                imageUrl: widget.user.profileImageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 50,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                    // Edit Icon
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: pickImage, // Function to pick an image
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xFF344CB7),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Bio",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            //pick image Button
            Container(
              decoration: BoxDecoration(
                color: const Color(
                    0xFFD6E4F0), // Light Blue background for the field
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: TextField(
                controller: bioTextController, // Set the controller here
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter your bio',
                  hintStyle:
                      TextStyle(color: Colors.black), // Light hint text color
                  border: InputBorder.none, // Remove border
                  contentPadding:
                      EdgeInsets.all(16), // Padding inside the text field
                ),
                style: const TextStyle(
                  color: Colors.black, // Black text color
                ),
              ),
            ),
            const SizedBox(height: 10),
            //
            //
            //
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC4D1E9), // Rich Blue Button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                onPressed: updateProfile,
                child: const Text(
                  'upload',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
