import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/auth/presentation/cubits/auth_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void resetPassword() async {
    final String email = emailController.text.trim();
    if (email.isNotEmpty) {
      final querySnapshot = await firebaseFirestore
          .collection('users') // Your users collection
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        context.read<AuthCubit>().forgotPassword(email);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email is not registered')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email to receive a password reset link.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                if (state is PasswordResetEmailSent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset email sent!")),
                  );
                  Navigator.pop(context);
                } else if (state is AuthErrors) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: resetPassword,
                  child: const Text("Send Reset Email"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
