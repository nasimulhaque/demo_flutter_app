import 'package:flutter_test/flutter_test.dart';
import 'package:demo_flutter_app/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('validateName', () {
      test('returns error for null name', () {
        expect(Validators.validateName(null), 'Name is required');
      });

      test('returns error for empty name', () {
        expect(Validators.validateName(''), 'Name is required');
      });

      test('returns error for name less than 3 characters', () {
        expect(Validators.validateName('Ab'), 'Name must be at least 3 characters');
      });

      test('returns null for valid name', () {
        expect(Validators.validateName('John Doe'), null);
      });
    });

    group('validateEmail', () {
      test('returns error for null email', () {
        expect(Validators.validateEmail(null), 'Email is required');
      });

      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), 'Email is required');
      });

      test('returns error for invalid email (no @)', () {
        expect(Validators.validateEmail('testexample.com'), 'Enter a valid email');
      });

      test('returns error for invalid email (no domain)', () {
        expect(Validators.validateEmail('test@'), 'Enter a valid email');
      });

      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), null);
      });
    });

    group('validatePassword', () {
      test('returns error for null password', () {
        expect(Validators.validatePassword(null), 'Password is required');
      });

      test('returns error for empty password', () {
        expect(Validators.validatePassword(''), 'Password is required');
      });

      test('returns error for password less than 6 characters', () {
        expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
      });

      test('returns null for valid password', () {
        expect(Validators.validatePassword('password123'), null);
      });
    });

    group('validateConfirmPassword', () {
      test('returns error for null confirmation', () {
        expect(Validators.validateConfirmPassword(null, 'pass123'), 'Please confirm your password');
      });

      test('returns error for empty confirmation', () {
        expect(Validators.validateConfirmPassword('', 'pass123'), 'Please confirm your password');
      });

      test('returns error when passwords do not match', () {
        expect(Validators.validateConfirmPassword('pass456', 'pass123'), 'Passwords do not match');
      });

      test('returns null when passwords match', () {
        expect(Validators.validateConfirmPassword('pass123', 'pass123'), null);
      });
    });

    group('validateAddress', () {
      test('returns error for null address', () {
        expect(Validators.validateAddress(null), 'Address is required');
      });

      test('returns error for empty address', () {
        expect(Validators.validateAddress(''), 'Address is required');
      });

      test('returns error for address less than 10 characters', () {
        expect(Validators.validateAddress('123 Main'), 'Please enter complete address');
      });

      test('returns null for valid address', () {
        expect(Validators.validateAddress('123 Main Street, Apt 4B'), null);
      });
    });

    group('validatePhone', () {
      test('returns error for null phone', () {
        expect(Validators.validatePhone(null), 'Phone number is required');
      });

      test('returns error for empty phone', () {
        expect(Validators.validatePhone(''), 'Phone number is required');
      });

      test('returns error for phone less than 10 digits', () {
        expect(Validators.validatePhone('123456789'), 'Enter valid phone number');
      });

      test('returns null for valid phone', () {
        expect(Validators.validatePhone('1234567890'), null);
      });
    });

    group('validateCoupon', () {
      test('returns null for empty coupon', () {
        expect(Validators.validateCoupon(''), null);
      });

      test('returns null for SAVE10 coupon', () {
        expect(Validators.validateCoupon('SAVE10'), null);
      });

      test('returns null for WELCOME20 coupon (case insensitive)', () {
        expect(Validators.validateCoupon('welcome20'), null);
      });

      test('returns error for invalid coupon', () {
        expect(Validators.validateCoupon('INVALID'), 'Invalid coupon code');
      });
    });

    group('applyCoupon', () {
      test('applies 10% discount for SAVE10', () {
        expect(Validators.applyCoupon('SAVE10', 100.0), 90.0);
      });

      test('applies 20% discount for WELCOME20', () {
        expect(Validators.applyCoupon('WELCOME20', 100.0), 80.0);
      });

      test('returns original price for invalid coupon', () {
        expect(Validators.applyCoupon('INVALID', 100.0), 100.0);
      });

      test('is case insensitive', () {
        expect(Validators.applyCoupon('save10', 100.0), 90.0);
        expect(Validators.applyCoupon('welcome20', 100.0), 80.0);
      });
    });
  });
}