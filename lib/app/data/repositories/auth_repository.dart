import 'package:flutter/foundation.dart';

class AuthRepository {
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@test.com' && password == 'password') {
      debugPrint('Login successful');
      return;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    debugPrint('Registration successful for $email');
    return;
  }
}
