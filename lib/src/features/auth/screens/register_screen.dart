import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enmay_flutter_starter/src/core/widgets/app_icon_button.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
      context.read<AuthCubit>().register(email, password);
    } else {
      form.markAllAsTouched();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Registration Failed'),
                  backgroundColor: colorScheme.error,
                ),
              );
          } else if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: const Text('Registration Successful! Please Login.'), backgroundColor: Colors.green),
              );
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ReactiveForm(
                formGroup: form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Get Started',
                      style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text('Create an account to continue', style: textTheme.titleMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 40),
                    ReactiveTextField<String>(
                      formControlName: 'name',
                      decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validationMessages: {ValidationMessage.required: (_) => 'Please enter your name'},
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'email',
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                      keyboardType: TextInputType.emailAddress,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please enter your email',
                        ValidationMessage.email: (_) => 'Please enter a valid email',
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'password',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please enter a password',
                        ValidationMessage.minLength:
                            (error) => 'Password must be at least ${(error as Map)['requiredLength']} characters',
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'confirmPassword',
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Please confirm your password',
                        ValidationMessage.mustMatch: (_) => 'Passwords do not match',
                      },
                    ),
                    const SizedBox(height: 32),
                    if (state.status == AuthStatus.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ReactiveFormConsumer(
                        builder: (context, formGroup, child) {
                          return ElevatedButton(
                            onPressed: formGroup.valid ? _register : null,
                            child: const Text('Register'),
                          );
                        },
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Or Register With',
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIconButton(
                          icon: FontAwesomeIcons.google,
                          onPressed: () {
                            /* TODO: Implement Google Sign In */
                          },
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 16),
                        AppIconButton(
                          icon: FontAwesomeIcons.facebookF,
                          onPressed: () {
                            /* TODO: Implement Facebook Sign In */
                          },
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 16),
                        AppIconButton(
                          icon: FontAwesomeIcons.apple,
                          onPressed: () {
                            /* TODO: Implement Apple Sign In */
                          },
                          color: colorScheme.onSurface,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: colorScheme.onSurfaceVariant),
                            ),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}
