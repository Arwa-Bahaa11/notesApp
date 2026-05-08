import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/utils/app_validator.dart';
import 'package:notes/presentation/pages/notes_page.dart';
import '../cubits/register/register_cubit.dart';
import '../cubits/register/register_state.dart';
import '../widgets/custom_auth_field.dart';
import '../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF2D2A70), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -30,
            left: -30,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: const Color(0xFF2D2A70).withValues(alpha: 0.05),
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
                    const SizedBox(height: 20),
                    const Text(
                      "Join Tarteeb",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2A70),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create your study profile to keep your notes organized.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                    const SizedBox(height: 40),
                    CustomAuthField(
                      label: "Full Name",
                      hint: "Arwa Bahaa",
                      prefixIcon: Icons.person_outline_rounded,
                      controller: nameController,
                      validator: AppValidator.validateName,
                    ),
                    const SizedBox(height: 20),
                    CustomAuthField(
                      label: "Email",
                      hint: "student@gmail.com",
                      prefixIcon: Icons.school_outlined,
                      controller: emailController,
                      validator: AppValidator.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    CustomAuthField(
                      label: "Password",
                      hint: "••••••••",
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      controller: passwordController,
                      validator: AppValidator.validatePassword,
                    ),
                    const SizedBox(height: 40),
                    BlocConsumer<RegisterCubit, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterSuccess) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotesPage()),
                            (route) => false,
                          );
                        } else if (state is RegisterError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomMainButton(
                          text: "Create account",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<RegisterCubit>().register(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                  );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Color(0xFF2D2A70),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
