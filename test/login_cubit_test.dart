import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/auth/domain/usecases/login_usecase.dart';
import 'package:notes/features/auth/domain/usecases/register_usecase.dart';
import 'package:notes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:notes/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();

    authCubit = AuthCubit(
      loginUsecase: mockLoginUsecase,
      registerUsecase: mockRegisterUsecase,
    );
  });

  tearDown(() => authCubit.close());

  // ─────────────────────────────────────────
  group('AuthCubit - Login Tests', () {
    const tEmail = 'h@test.com';
    const tPassword = '123456';

    test('Initial state should be AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Success] when login succeeds',
      build: () {
        when(() => mockLoginUsecase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
      verify: (_) {
        verify(() => mockLoginUsecase(
          email: tEmail,
          password: tPassword,
        )).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Error] when login fails',
      build: () {
        when(() => mockLoginUsecase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('Login Failed'));
        return authCubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );
  });

  // ─────────────────────────────────────────
  group('AuthCubit - Register Tests', () {
    const tName = 'Habiba';
    const tEmail = 'h@test.com';
    const tPassword = '123456';

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Success] when register succeeds',
      build: () {
        when(() => mockRegisterUsecase(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.register(tName, tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRegisterUsecase(
          name: tName,
          email: tEmail,
          password: tPassword,
        )).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Error] when register fails',
      build: () {
        when(() => mockRegisterUsecase(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('Register Failed'));
        return authCubit;
      },
      act: (cubit) => cubit.register(tName, tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );
  });
}