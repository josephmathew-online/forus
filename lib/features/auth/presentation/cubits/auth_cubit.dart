import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/domain/repository/auth_repo.dart';
import 'package:cc/features/auth/presentation/cubits/auth_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // Method to convert Firebase User to AppUser
  AppUser _convertFirebaseUserToAppUser(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: firebaseUser.displayName ?? 'Unknown',
    );
  }

  // ✅ Check if the user is authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // ✅ Forgot Password (Trigger Email Reset)
  Future<void> forgotPassword(String email) async {
    try {
      emit(AuthLoading());
      await authRepo.resetPassword(email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      emit(AuthErrors("Failed to send reset email: $e"));
    }
  }

  // ✅ Get current user
  AppUser? get currentUser => _currentUser;

  // ✅ Register function
  Future<bool> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading()); // Start loading when trying to register

      // Register user
      final user = await authRepo.registerWithEmailPassword(name, email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user)); // Emit authenticated state directly
        return true;
      } else {
        emit(Unauthenticated());
        return false;
      }
    } catch (e) {
      emit(AuthErrors(e.toString()));
      return false;
    }
  }

  // ✅ Check email verification status
  Future<void> checkEmailVerification() async {
    try {
      User? user = firebaseAuth.currentUser;
      await user?.reload(); // Reload user data to get fresh status

      if (user != null && user.emailVerified) {
        // Convert Firebase user to AppUser
        AppUser appUser = _convertFirebaseUserToAppUser(user);

        _currentUser = appUser;
        emit(Authenticated(
            appUser)); // If email is verified, emit authenticated state
      } else {
        // If not verified, show the message
        emit(AuthErrors('Please verify your email.'));
      }
    } catch (e) {
      emit(AuthErrors('Error checking email verification: $e'));
    }
  }

  // ✅ Login function
  Future<bool> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
        return true;
      } else {
        emit(Unauthenticated());
        return false;
      }
    } catch (e) {
      emit(AuthErrors(e.toString()));
      emit(AuthInitial());
      return false;
    }
  }

  // ✅ Logout function
  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await authRepo.logout();
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthErrors("Logout failed: $e"));
    }
  }
}
