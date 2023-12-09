import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallBack = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallBack: registerUserCallBack);
});

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier({
    required this.registerUserCallBack,
  }) : super(RegisterFormState());

  final Function(String, String, String) registerUserCallBack;

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        newEmail,
        state.password,
        state.fullname,
        state.confirmPassword,
      ]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([
        newPassword,
        state.email,
        state.fullname,
        state.confirmPassword,
      ]),
    );
  }

  onFullnameChange(String value) {
    final newFullname = Fullname.dirty(value);
    state = state.copyWith(
      fullname: newFullname,
      isValid: Formz.validate([
        newFullname,
        state.password,
        state.email,
        state.confirmPassword,
      ]),
    );
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = ConfirmPassword.dirty(value);
    final password = state.password;

    if (Formz.validate([password, newConfirmPassword])) {
      final bool passwordMatch = password.value == newConfirmPassword.value;

      state = state.copyWith(
        passwordMatched: passwordMatch,
        confirmPassword: newConfirmPassword,
        isValid: Formz.validate([state.email, state.fullname]) && passwordMatch,
      );
    }

    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: false,
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    await registerUserCallBack(
      state.email.value,
      state.password.value,
      state.fullname.value,
    );
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(state.confirmPassword.value);
    final fullname = Fullname.dirty(state.fullname.value);

    if (Formz.validate([password, confirmPassword])) {
      final bool passwordMatch = password.value == confirmPassword.value;

      state = state.copyWith(
        isFormPosted: true,
        passwordMatched: passwordMatch,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        fullname: fullname,
        isValid: Formz.validate([email, fullname]) && passwordMatch,
      );
    } else {
      state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        fullname: fullname,
        isValid: false,
      );
    }
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool passwordMatched;
  final Email email;
  final Password password;
  final Fullname fullname;
  final ConfirmPassword confirmPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.passwordMatched = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.fullname = const Fullname.pure(),
  });

  @override
  String toString() {
    return """
LoginFormState:
  isPosting: $isPosting
  isFormPosted: $isFormPosted
  isValid: $isValid
  email: $email
  password: $password
  confirmPassword: $confirmPassword
  fullname: $fullname
""";
  }

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? passwordMatched,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    Fullname? fullname,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        passwordMatched: passwordMatched ?? this.passwordMatched,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        fullname: fullname ?? this.fullname,
      );
}
