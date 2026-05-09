import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/domain/repositories/auth_repository.dart';
import 'package:notes/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUsecase(repository: mockAuthRepository);
  });

  const tName = 'Habiba';
  const tEmail = 'test@test.com';
  const tPassword = 'password123';
  final tUser = User(
    id: 1,
    name: tName,
    email: tEmail,
    token: 'token_123_xyz',
  );

  test(
    'Repository correct',
        () async {
      when(() => mockAuthRepository.register(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => tUser);

      final result = await usecase.call(
        name: tName,
        email: tEmail,
        password: tPassword,
      );
      expect(result, equals(tUser));
      verify(() => mockAuthRepository.register(
        name: tName,
        email: tEmail,
        password: tPassword,
      )).called(1);

      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'Registration fails',
        () async {
      const errorMessage = 'Email already in use';
      when(() => mockAuthRepository.register(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(errorMessage);

      expect(
            () => usecase.call(name: tName, email: tEmail, password: tPassword),
        throwsA(errorMessage),
      );
    },
  );
}