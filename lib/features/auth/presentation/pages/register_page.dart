import 'package:cc/features/auth/presentation/components/my_Button.dart';
import 'package:cc/features/auth/presentation/components/my_Text_Field.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.togglePages});
  void Function()? togglePages;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmpwController = TextEditingController();
  final nameController = TextEditingController();
  bool emailSent = false; // Track if email verification is sent

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmpw = confirmpwController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty &&
        name.isNotEmpty &&
        pw.isNotEmpty &&
        confirmpw.isNotEmpty) {
      if (pw == confirmpw) {
        if (email.split('@')[1] == 'sngce.ac.in') {
          //sng21cs006 @ sngce.ac.in
          authCubit.register(name, email, pw);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Enter sng mail")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Complete all fields")));
    }
  }

  void verifyEmail() {
    context.read<AuthCubit>().checkEmailVerification();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    confirmpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),
                  Image.asset(
                    "lib/images/logo/forus.png",
                    scale: 1.7,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Create an account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                      controller: nameController,
                      hintText: "Name",
                      obscureText: false),
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false),
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: pwController,
                      hintText: "Password",
                      obscureText: true),
                  const SizedBox(height: 15),
                  MyTextField(
                      controller: confirmpwController,
                      hintText: "Confirm Password",
                      obscureText: true),
                  const SizedBox(height: 20),

                  // Bloc Listener to track state changes
                  BlocListener<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is EmailVerificationSent) {
                        setState(() => emailSent = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Verification email sent. Please check your inbox.")),
                        );
                      } else if (state is Authenticated) {
                        Navigator.pushReplacementNamed(context, "/home");
                      } else if (state is AuthErrors) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        MyButton(onTap: register, text: 'Register'),
                        if (emailSent) ...[
                          const SizedBox(height: 20),
                          MyButton(onTap: verifyEmail, text: 'I Verified'),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already a member? '),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
