import 'package:flutter/material.dart';
import 'package:notes/presentation/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../cubits/register/register_cubit.dart';
import '../cubits/register/register_state.dart';
import '../widgets/custom_auth_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Fill the details below to get started", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),

              CustomAuthField(
                label: "Full Name",
                hint: "Enter your name",
                prefixIcon: Icons.person_outline,
                controller: nameController,
              ),
              const SizedBox(height: 20),

              CustomAuthField(
                label: "Email Address",
                hint: "you@example.com",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
              ),
              const SizedBox(height: 20),

              CustomAuthField(
                label: "Password",
                hint: "Create a password",
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
                suffixIcon: const Icon(Icons.visibility_off_outlined),
              ),
              const SizedBox(height: 40),

              // الـ Logic المربوط بالـ RegisterCubit
              Consumer<RegisterCubit>(
                builder: (context, cubit, child) {
                  if (cubit.state is RegisterLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomMainButton(
                    text: "Sign Up",
                    onPressed: () {
                      cubit.register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                    },
                  );
                },
              ),
              
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(text: "Log In", style: TextStyle(color: Color(0xFF2D2A70), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}