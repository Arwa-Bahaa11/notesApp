import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/features/auth/domain/usecases/login_usecase.dart';
import 'package:notes/features/auth/domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  AuthCubit({required this.loginUsecase, required this.registerUsecase})
      : super(AuthInitial());
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await loginUsecase(email: email, password: password);
      emit(AuthSuccess("Login successful"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      await registerUsecase(name: name, email: email, password: password);
      emit(AuthSuccess("Registration successful"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
