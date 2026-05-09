import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/domain/repositories/auth_repository.dart';
import 'package:notes/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUsecase(repository: mockAuthRepository);
  });

  const tEmail = 'test@test.com';
  const tPassword = 'password123';
  final tUser = User(
    id: 1,
    name: 'Habiba',
    email: tEmail,
    token: 'token_abc',
  );

  test(
    'should call login on the repository with correct parameters',
        () async {
      // Arrange: Setup the mock to return a Future of User
      when(() => mockAuthRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => tUser);

      // Act: Execute the usecase
      final result = await usecase.call(email: tEmail, password: tPassword);

      // Assert: Verify the result is the user we expected
      expect(result, equals(tUser));

      // Verify that the repository method was called exactly once with specific data
      verify(() => mockAuthRepository.login(
        email: tEmail,
        password: tPassword,
      )).called(1);

      // Ensure no other methods were called on the repository
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should throw an exception when the repository login fails',
        () async {
      when(() => mockAuthRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow('Invalid Credentials');
      expect(
            () => usecase.call(email: tEmail, password: tPassword),
        throwsA('Invalid Credentials'),
      );
    },
  );
}