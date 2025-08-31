import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.formControlName,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validationMessages = const {},
    this.onSuffixIconPressed,
  });

  final String formControlName;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Map<String, String Function(Object)> validationMessages;
  final VoidCallback? onSuffixIconPressed;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: formControlName,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon: suffixIcon!,
              )
            : null,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validationMessages: validationMessages,
    );
  }
}

class AppPasswordTextField extends StatefulWidget {
  const AppPasswordTextField({
    super.key,
    required this.formControlName,
    this.labelText = 'Password',
    this.validationMessages = const {},
  });

  final String formControlName;
  final String? labelText;
  final Map<String, String Function(Object)> validationMessages;

  @override
  State<AppPasswordTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<AppPasswordTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      formControlName: widget.formControlName,
      labelText: widget.labelText,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: Icon(
        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      ),
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      validationMessages: widget.validationMessages,
      onSuffixIconPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    );
  }
}