import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/components/my_Button.dart';
import 'package:cc/features/auth/presentation/components/my_Text_Field.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/auth/presentation/components/google.dart';
import 'package:cc/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:cc/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  void Function()? togglePages;
  LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  void _handleGoogleSignIn(BuildContext context) async {
    try {
      final authCubit = context.read<AuthCubit>(); // Get the AuthCubit instance
      AppUser? user = await authCubit.authRepo.loginWithGoogle(); // Call login

      if (user != null) {
        authCubit.checkAuth(); // ✅ Ensure AuthCubit updates state

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        ); // Navigate after auth state is updated
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found in database.")),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    }
  }

  // ignore: non_constant_identifier_names
  void LogIn() {
    final String email = emailController.text;
    final String pw = pwController.text;

    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('please enter both email and password')));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Image.asset(
                    "lib/images/logo/forus.png",
                    scale: 1.7,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'together. everywhere.',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false),
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: pwController,
                      hintText: "Password",
                      obscureText: true),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage())),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    const Color.fromARGB(255, 138, 138, 138)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyButton(onTap: LogIn, text: 'LOGIN'),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Or"),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      )
                    ]),
                  ),
                  Google(
                    text: 'Continue with Google',
                    onPressed: () => _handleGoogleSignIn(context),
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: Text(
                          ' Register now.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
