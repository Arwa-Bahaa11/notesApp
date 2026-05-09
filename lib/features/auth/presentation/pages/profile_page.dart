import 'package:flutter/material.dart';
import 'package:notes/core/constants/app_colors.dart';
import 'package:notes/core/utils/local_storage.dart';
import 'package:notes/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = LocalStorage.getName() ?? "Student";
    final email = LocalStorage.getEmail() ?? "";

    return Scaffold(
      backgroundColor: AppColors.scafoldBackground,
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(
                color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // The Professional "Student ID" Avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    width: 3),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "S",
                  style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.errorColor,
                  side: const BorderSide(color: AppColors.errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Logout",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await LocalStorage.clearAll();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
