import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/presentation/cubits/login/login_cubit.dart';
import 'package:notes/presentation/cubits/login/login_state.dart';
import 'package:notes/data/repo/auth_repo.dart';
import 'package:notes/data/models/user_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginCubit loginCubit;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    loginCubit = LoginCubit(mockRepo);
  });

  group('LoginCubit Unit Tests', () {
    final mockUser = UserModel(id: 1, name: 'Habiba', email: 'h@test.com', token: '');

    test('Initial state should be LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Success] when login is successful',
      build: () {
        final Future<UserModel> successResponse = Future.value(mockUser);

        when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) => successResponse);

        return loginCubit;
      },
      act: (cubit) => cubit.login('h@test.com', '123456'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
    );
    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Error] when login fails',
      build: () {
        when(() => mockRepo.login(
            email: 'h@test.com',
            password: 'wrong'
        )).thenThrow(Exception('Login Failed'));

        return loginCubit;
      },
      act: (cubit) => cubit.login('h@test.com', 'wrong'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginError>(),
      ],
    );
  });
}