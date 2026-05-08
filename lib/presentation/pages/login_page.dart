import 'package:flutter/material.dart';
import 'package:notes/presentation/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../cubits/login/login_cubit.dart';
import '../cubits/login/login_state.dart';
import '../widgets/custom_auth_field.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2A70),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.book, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: Text("Tarteeb", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
              const SizedBox(height: 40),
              const Text("Welcome back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("Log in to your account to continue", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),

              CustomAuthField(
                label: "Email address",
                hint: "you@example.com",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
              ),
              const SizedBox(height: 20),

              CustomAuthField(
                label: "Password",
                hint: "Enter your password",
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
                suffixIcon: const Icon(Icons.visibility_off_outlined),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password?", style: TextStyle(color: Color(0xFF2D2A70))),
                ),
              ),
              const SizedBox(height: 24),

              // الـ Logic المربوط بالـ LoginCubit
              Consumer<LoginCubit>(
                builder: (context, cubit, child) {
                  if (cubit.state is LoginLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomMainButton(
                    text: "Login",
                    onPressed: () {
                      cubit.login(emailController.text, passwordController.text);
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                  },
                  child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF2D2A70))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}