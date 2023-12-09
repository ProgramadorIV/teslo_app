import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/register_form_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (!context.canPop()) return;
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back_rounded,
                            size: 25, color: Colors.white)),
                    const Spacer(flex: 1),
                    Text('Create account',
                        style: size.width < 400
                            ? textStyles.titleSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 25,
                              )
                            : textStyles.titleMedium
                                ?.copyWith(color: Colors.white)),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox(height: 50),

                Container(
                  height: size.height < 670
                      ? size.height + 50
                      : size.height, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: _RegisterForm(size: size),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context, ref) {
    final textStyles = Theme.of(context).textTheme;

    final registerForm = ref.watch(registerFormProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            'New account',
            style: size.width < 400
                ? textStyles.titleSmall?.copyWith(fontSize: 25)
                : textStyles.titleMedium,
          ),
          const SizedBox(height: 50),
          CustomTextFormField(
            label: 'Fullname',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onFullnameChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.fullname.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.email.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Password',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Confirm password',
            obscureText: true,
            onChanged:
                ref.read(registerFormProvider.notifier).onConfirmPasswordChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.passwordMatched
                    ? null
                    : 'Passwords provided do not match'
                : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Create',
                buttonColor: Colors.black,
                onPressed: ref.read(registerFormProvider.notifier).onFormSubmit,
              )),
          const SizedBox(
            height: 10,
          ),
          if (size.width > 360)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Click here'),
                ),
              ],
            ),
          if (size.width < 360)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Click here'),
                ),
              ],
            ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
