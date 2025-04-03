import 'package:enmay_flutter_starter/app/core/widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final FormGroup form = FormGroup({
    'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(validators: [Validators.required]),
    'rememberMe': FormControl<bool>(value: false),
  });

  void _login() {
    if (form.valid) {
      final email = form.control('email').value as String;
      final password = form.control('password').value as String;
      context.read<AuthCubit>().login(email, password);
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
      appBar: AppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failed'),
                  // colo: colorScheme.error,
                ),
              );
          } else if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: const Text('Login Successful!'), backgroundColor: Colors.green));
            // TODO: Navigate to the main app screen
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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
                      'Welcome Back!',
                      style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text('Sign in to continue', style: textTheme.titleMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 40),
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
                      validationMessages: {ValidationMessage.required: (_) => 'Please enter your password'},
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 24.0,
                                width: 24.0,
                                child: ReactiveCheckbox(formControlName: 'rememberMe'),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  final control = form.control('rememberMe');
                                  control.value = !(control.value as bool? ?? false);
                                },
                                child: Text('Remember Me', style: textTheme.bodyMedium),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (state.status == AuthStatus.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ReactiveFormConsumer(
                        builder: (context, formGroup, child) {
                          return ElevatedButton(onPressed: formGroup.valid ? _login : null, child: const Text('Login'));
                        },
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Or Login With',
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
                        AppIconButton(icon: FontAwesomeIcons.google, onPressed: () {}, color: Colors.redAccent),
                        const SizedBox(width: 16),
                        AppIconButton(icon: FontAwesomeIcons.facebookF, onPressed: () {}, color: Colors.blueAccent),
                        const SizedBox(width: 16),
                        AppIconButton(icon: FontAwesomeIcons.apple, onPressed: () {}, color: colorScheme.onSurface),
                      ],
                    ),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: colorScheme.onSurfaceVariant),
                            ),
                            TextSpan(
                              text: "Register",
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
