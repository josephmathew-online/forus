import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/domain/repository/auth_repo.dart';
import 'package:cc/features/notification/data/token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user profile from Firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User not found in database.");
      }

      saveTokenToFirestore();

      // Return authenticated user
      return AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc['name'],
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> isEmailVerified() async {
    await firebaseAuth.currentUser?.reload(); // Refresh user state
    return firebaseAuth.currentUser?.emailVerified ?? false;
  }

  // 🔹 Register with Email & Password
  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // Sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Store user details in Firestore
        await firebaseFirestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
        });

        return AppUser(uid: user.uid, email: email, name: name);
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // 🔹 Reset Password (Send Password Reset Email)
  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  // 🔹 Login with Google (ONLY if user is already registered)
  @override
  Future<AppUser?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in process
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Google sign-in failed.");
      }

      // Check if user exists in Firestore based on email
      final QuerySnapshot userQuery = await firebaseFirestore
          .collection('users')
          .where('email', isEqualTo: firebaseUser.email)
          .get();

      if (userQuery.docs.isEmpty) {
        // If no user found, sign out and show error
        await firebaseAuth.signOut();
        await googleSignIn.signOut();
        throw Exception("User not found. Please register first.");
      }

      // Extract user data from Firestore
      final DocumentSnapshot userDoc = userQuery.docs.first;
      final String name =
          userDoc['name'] ?? firebaseUser.displayName ?? 'Unknown';
      final String email = userDoc['email'] ?? firebaseUser.email ?? '';

      // Save token for notifications or authentication
      saveTokenToFirestore();

      // Return the logged-in user
      return AppUser(
        uid: firebaseUser.uid,
        email: email,
        name: name,
      );
    } catch (e) {
      throw Exception("Google Sign-In failed: $e");
    }
  }

  // 🔹 Logout
  @override
  Future<void> logout() async {
    try {
      await removeToken(); // Call before sign out
      await firebaseAuth.signOut();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // ignore: empty_catches
    } catch (e) {}
  }

  // 🔹 Get Current User
  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    DocumentSnapshot userDoc =
        await firebaseFirestore.collection("users").doc(firebaseUser.uid).get();

    if (!userDoc.exists) return null;

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: userDoc['name'],
    );
  }
}
