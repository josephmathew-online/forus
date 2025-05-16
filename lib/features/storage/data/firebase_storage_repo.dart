import 'dart:io';
import 'dart:typed_data';

import 'package:cc/features/storage/domain/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_image");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileByte, String fileName) {
    return _uploadFileBytes(fileByte, fileName, "profile_image");
  }

  //helper methods to upload file to storage

  //post images -upload to storage
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  ///
  ///
  ///
  ///uploading for items in lost and found
  @override
  Future<String?> uploadItemImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "item_images");
  }

  @override
  Future<String?> uploadItemImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "item_images");
  }

  ///
  ///
  ///
  ///
  //////

  // mobile platform (file)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);

      //finad place to store
      final stroageRef = storage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await stroageRef.putFile(file);

      //get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _uploadFileBytes(
      Uint8List fileByte, String fileName, String folder) async {
    try {
      //finad place to store
      final stroageRef = storage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await stroageRef.putData(fileByte);

      //get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
  //web platform
}
