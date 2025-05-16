//possible operations for this app
import 'package:cc/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);
  Future<AppUser?> loginWithGoogle();
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<void> resetPassword(String email);
}
