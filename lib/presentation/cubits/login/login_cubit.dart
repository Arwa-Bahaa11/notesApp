import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/data/repo/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginCubit(this._repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      await _repository.login(email: email, password: password);
      emit(LoginSuccess("تم تسجيل الدخول بنجاح"));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}