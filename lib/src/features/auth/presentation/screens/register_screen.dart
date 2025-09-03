import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enmay_flutter_starter/src/core/widgets/app_logo.dart';
import 'package:enmay_flutter_starter/src/core/widgets/app_text_field.dart';
import 'package:enmay_flutter_starter/src/core/widgets/social_auth_buttons.dart';
import 'package:enmay_flutter_starter/src/core/widgets/app_button.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../provider/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final FormGroup form = FormGroup(
    {
      'name': FormControl<String>(validators: [Validators.required]),
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
      'password': FormControl<String>(validators: [Validators.required, Validators.minLength(6)]),
      'confirmPassword': FormControl<String>(validators: [Validators.required]),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );

  void _register() {
    if (form.valid) {
      final email = form.control('email').value as String;
      final password = form.control('password').value as String;
      ref.read(authNotifierProvider.notifier).registerWithEmail(email, password);
    } else {
      form.markAllAsTouched();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AsyncValue>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(next.error.toString()),
              backgroundColor: colorScheme.error,
            ),
          );
      } else if (next.hasValue && next.value != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: const Text('Registration Successful!'),
              backgroundColor: colorScheme.primary,
            ),
          );
        Navigator.pop(context);
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ReactiveForm(
                formGroup: form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const AppLogo(size: 80),
                    const SizedBox(height: 32),
                    Text(
                      'Create Account',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    AppTextField(
                      formControlName: 'name',
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      keyboardType: TextInputType.name,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please enter your name'
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      formControlName: 'email',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please enter your email',
                        ValidationMessage.email: (_) => 'Please enter a valid email',
                      },
                    ),
                    const SizedBox(height: 16),
                    AppPasswordTextField(
                      formControlName: 'password',
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please enter a password',
                        ValidationMessage.minLength: (error) => 
                            'Password must be at least ${(error as Map)['requiredLength']} characters',
                      },
                    ),
                    const SizedBox(height: 16),
                    AppPasswordTextField(
                      formControlName: 'confirmPassword',
                      labelText: 'Confirm Password',
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please confirm your password',
                        ValidationMessage.mustMatch: (_) => 'Passwords do not match',
                      },
                    ),
                    const SizedBox(height: 32),
                    ReactiveFormConsumer(
                      builder: (context, formGroup, child) {
                        final isLoading = authState.isLoading;
                        return AppButton(
                          onPressed: (formGroup.valid && !isLoading) ? _register : null,
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.lg,
                          width: double.infinity,
                          isLoading: isLoading,
                          child: const Text('Create Account'),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    SocialAuthButtons(
                      onGooglePressed: () {},
                      onApplePressed: () {},
                      onFacebookPressed: () {},
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          variant: AppButtonVariant.link,
                          size: AppButtonSize.sm,
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}