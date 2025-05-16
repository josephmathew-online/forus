import 'dart:typed_data';

abstract class StorageRepo {
  //upload profile images on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  //upload profile image on web platforms
  Future<String?> uploadProfileImageWeb(Uint8List fileByte, String fileName);

  //upload post images on mobile platforms
  Future<String?> uploadPostImageMobile(String path, String fileName);

  //upload post image on web platforms
  Future<String?> uploadPostImageWeb(Uint8List fileByte, String fileName);

  //upload item images on mobile platforms
  Future<String?> uploadItemImageMobile(String path, String fileName);

  //upload item image on web platforms
  Future<String?> uploadItemImageWeb(Uint8List fileByte, String fileName);
}
