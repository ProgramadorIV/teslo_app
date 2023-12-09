import 'package:formz/formz.dart';

// Define input validation errors
enum FullnameError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Fullname extends FormzInput<String, FullnameError> {
  // Call super.pure to represent an unmodified form input.
  const Fullname.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Fullname.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == FullnameError.empty) return 'This field is required';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  FullnameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return FullnameError.empty;

    return null;
  }
}
