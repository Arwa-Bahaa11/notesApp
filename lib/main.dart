import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/utils/local_storage.dart';
import 'package:notes/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notes/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:notes/features/auth/domain/usecases/login_usecase.dart';
import 'package:notes/features/auth/domain/usecases/register_usecase.dart';
import 'package:notes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:notes/features/auth/presentation/pages/login_page.dart';
import 'package:notes/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:notes/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:notes/features/notes/domain/usecases/notes_usecases.dart';
import 'package:notes/features/notes/presentation/cubit/notes_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(
              loginUsecase: LoginUsecase(
                repository: AuthRepositoryImpl(
                  remoteDatasource: AuthRemoteDatasource(),
                ),
              ),
              registerUsecase: RegisterUsecase(
                repository: AuthRepositoryImpl(
                  remoteDatasource: AuthRemoteDatasource(),
                ),
              ),
            ),
          ),
          BlocProvider(
            create: (_) => NotesCubit(
              getNotesUsecase: GetNotesUsecase(
                repository: NotesRepositoryImpl(
                  remoteDatasource: NotesRemoteDatasource(),
                ),
              ),
              addNoteUsecase: AddNoteUsecase(
                repository: NotesRepositoryImpl(
                  remoteDatasource: NotesRemoteDatasource(),
                ),
              ),
              editNoteUsecase: EditNoteUsecase(
                repository: NotesRepositoryImpl(
                  remoteDatasource: NotesRemoteDatasource(),
                ),
              ),
              deleteNoteUsecase: DeleteNoteUsecase(
                repository: NotesRepositoryImpl(
                  remoteDatasource: NotesRemoteDatasource(),
                ),
              ),
            ),
          ),
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
