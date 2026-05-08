import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/utils/local_storage.dart';
import 'package:notes/data/repo/note_repository.dart';
import 'package:notes/presentation/cubits/notes/add_note/add_note_cubit.dart';
import 'package:notes/presentation/cubits/notes/get_notes/get_notes_cubit.dart';
import 'package:notes/presentation/cubits/notes/manage_note/manage_note_cubit.dart';
import 'presentation/cubits/login/login_cubit.dart';
import 'presentation/cubits/register/register_cubit.dart';
import 'presentation/pages/login_page.dart';
import 'package:notes/data/repo/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  final authRepo = AuthRepository();
  final noteRepo = NoteRepository();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginCubit(authRepo)),
          BlocProvider(create: (_) => RegisterCubit(authRepo)),
          BlocProvider(create: (_) => GetNotesCubit(noteRepo)),
          BlocProvider(create: (_) => AddNoteCubit(noteRepo)),
          BlocProvider(create: (_) => ManageNoteCubit(noteRepo)),
          BlocProvider(create: (_) => LoginCubit(authRepo)),
          BlocProvider(create: (_) => RegisterCubit(authRepo)),
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
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primaryColor: const Color(0xFF2D2A70),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const LoginPage(),
    );
  }
}
