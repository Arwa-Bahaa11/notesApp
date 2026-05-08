import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/data/repo/auth_repo.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(RegisterInitial());

  Future<void> register(String name, String email, String password) async {
    emit(RegisterLoading());
    try {
      await _repository.register(name: name, email: email, password: password);
      emit(RegisterSuccess("تم إنشاء الحساب بنجاح"));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}