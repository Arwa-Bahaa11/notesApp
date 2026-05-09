import 'package:flutter_test/flutter_test.dart';
import 'package:notes/core/utils/app_validator.dart';

void main() {
  group('AppValidator Unit Tests', () {

    group('Email Validation', () {
      test('Email is empty', () {
        expect(AppValidator.validateEmail(''), 'Email is required');
      });

      test('Email format is invalid', () {
        expect(AppValidator.validateEmail('invalid-email'), 'Please enter a valid email address');
      });

      test('Email format is valid', () {
        expect(AppValidator.validateEmail('test@university.edu'), isNull);
      });
    });

    group('Password Validation', () {
      test('Password < 6 characters', () {
        expect(AppValidator.validatePassword('12345'), 'Password must be at least 6 characters');
      });

      test('Password is 6 characters or more', () {
        expect(AppValidator.validatePassword('123456'), isNull);
      });
    });

    group('Name Validation', () {
      test('Name is empty', () {
        expect(AppValidator.validateName('   '), 'Full name is required');
      });

      test('Valid name', () {
        expect(AppValidator.validateName('Habiba'), isNull);
      });
    });

  });
}