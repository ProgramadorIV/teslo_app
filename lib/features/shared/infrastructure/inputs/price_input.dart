import 'package:formz/formz.dart';

// Define input validation errors
enum PriceError { empty, format, negative }

// Extend FormzInput and provide the input type and error type.
class Price extends FormzInput<double, PriceError> {
  // Call super.pure to represent an unmodified form input.
  const Price.pure() : super.pure(0.0);

  // Call super.dirty to represent a modified form input.
  const Price.dirty(double value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PriceError.empty) return 'This field is required';
    if (displayError == PriceError.format) return 'No number format';
    if (displayError == PriceError.negative) {
      return 'Can´t be less than 0.';
    }
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PriceError? validator(double value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return PriceError.empty;
    }

    if ((double.tryParse(value.toString()) ?? -1) == -1) {
      return PriceError.format;
    }

    if (value < 0) return PriceError.negative;
    return null;
  }
}
