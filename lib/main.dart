import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ← changed
import 'presentation/cubits/login/login_cubit.dart';
import 'presentation/cubits/register/register_cubit.dart';
import 'presentation/pages/login_page.dart';
import 'package:notes/data/repo/auth_repo.dart';

void main() {
  final authRepo = AuthRepository();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider( // ← changed
        providers: [
          BlocProvider(create: (_) => LoginCubit(authRepo)),   // ← changed
          BlocProvider(create: (_) => RegisterCubit(authRepo)), // ← changed
        ],
        child: const TarteebApp(),
      ),
    ),
  );
}

class TarteebApp extends StatelessWidget {
  const TarteebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarteeb App',
      
      // 4. إعدادات الـ Device Preview الضرورية
      useInheritedMediaQuery: true, 
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      // 5. الثيم العام للأبلكيشن (بناءً على اللون اللي اخترناه)
      theme: ThemeData(
        primaryColor: const Color(0xFF2D2A70),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins', // لو ضفتي فونت خارجي
      ),
      
      // 6. نقطة البداية (صفحة اللوجين)
      home: const LoginPage(),
    );
  }
}