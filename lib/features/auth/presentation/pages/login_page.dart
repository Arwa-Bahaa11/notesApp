import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/constants/app_colors.dart';
import 'package:notes/core/utils/app_validator.dart';
import 'package:notes/features/auth/presentation/widget/custom_auth_field.dart';
import 'package:notes/features/auth/presentation/widget/custom_button.dart';
import 'package:notes/features/notes/presentation/pages/notes_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.07),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: Column(
                        children: [
                          const Icon(Icons.edit_note_rounded,
                              color: Color(0xFF2D2A70), size: 80),
                          const Text(
                            "Tarteeb",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            "Organize your thoughts, Ace your exams.",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    CustomAuthField(
                      label: "Email",
                      hint: "student@university.edu",
                      prefixIcon: Icons.school_outlined,
                      controller: emailController,
                      validator: AppValidator.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    CustomAuthField(
                      label: "Password",
                      hint: "••••••••",
                      prefixIcon: Icons.lock_open_rounded,
                      isPassword: true,
                      controller: passwordController,
                      validator: AppValidator.validatePassword,
                    ),
                    const SizedBox(height: 40),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotesPage()),
                            (route) => false,
                          );
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomMainButton(
                          text: "Login",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFF2D2A70),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
