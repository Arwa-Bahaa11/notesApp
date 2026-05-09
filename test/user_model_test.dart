import 'package:flutter_test/flutter_test.dart';
import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/data/models/user_model.dart';

void main() {
  final tUserModel = UserModel(
    id: 1,
    name: 'Habiba',
    email: 'test@test.com',
    token: 'fake_token',
  );

  final tJson = {
    'id': 1,
    'name': 'Habiba',
    'email': 'test@test.com',
    'token': 'fake_token',
  };

  test('A subclass of User entity', () {
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    test('Valid model', () {
      final result = UserModel.fromJson(tJson);
      expect(result.id, tUserModel.id);
      expect(result.name, tUserModel.name);
      expect(result.email, tUserModel.email);
      expect(result.token, tUserModel.token);
    });
  });

  group('toJson', () {
    test('JSON map containing', () {
      final result = tUserModel.toJson();
      expect(result, tJson);
    });
  });
}