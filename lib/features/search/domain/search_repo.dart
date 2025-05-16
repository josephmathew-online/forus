import 'package:cc/features/profile/domain/entities/profile_user.dart';

abstract class SearchRepo {
  Stream<List<ProfileUser>> searchUsers(String query);
  Stream<List<ProfileUser>> getAllUsers();
}
