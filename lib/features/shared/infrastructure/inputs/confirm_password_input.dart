import 'package:formz/formz.dart';

// Define input validation errors
enum ConfirmPasswordError { empty, noMatch }

// Extend FormzInput and provide the input type and error type.
class ConfirmPassword extends FormzInput<String, ConfirmPasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const ConfirmPassword.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ConfirmPassword.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ConfirmPasswordError.empty) {
      return 'This field is required';
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return ConfirmPasswordError.empty;
    }
    return null;
  }
}
