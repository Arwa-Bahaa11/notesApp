import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/domain/usecases/login_usecase.dart';
import 'package:notes/features/auth/domain/usecases/register_usecase.dart';
import 'package:notes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:notes/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUsecase mockLogin;
  late MockRegisterUsecase mockRegister;

  final tUser = User(
    id: 1,
    name: 'Habiba',
    email: 'test@test.com',
    token: 'fake_token',
  );

  setUp(() {
    mockLogin = MockLoginUsecase();
    mockRegister = MockRegisterUsecase();
    authCubit = AuthCubit(
      loginUsecase: mockLogin,
      registerUsecase: mockRegister,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Tests', () {

    group('Login Method', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login is successful',
        build: () {
          when(() => mockLogin.call(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUser);
          return authCubit;
        },
        act: (cubit) => cubit.login('test@test.com', 'password123'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(() => mockLogin.call(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow('Invalid credentials');
          return authCubit;
        },
        act: (cubit) => cubit.login('test@test.com', 'wrong_pass'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
      );
    });

    group('Register Method', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthSuccess] when registration is successful',
        build: () {
          when(() => mockRegister.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUser);
          return authCubit;
        },
        act: (cubit) => cubit.register('Habiba', 'test@test.com', 'password123'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails',
        build: () {
          when(() => mockRegister.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow('Server error');
          return authCubit;
        },
        act: (cubit) => cubit.register('Habiba', 'test@test.com', 'password123'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
      );
    });
  });
}