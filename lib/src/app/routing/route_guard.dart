import 'dart:async';

import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteGuard extends ChangeNotifier {
  RouteGuard(this._ref) {
    _initialize();
  }

  final Ref _ref;
  StreamSubscription<User?>? _subscription;

  void _initialize() {
    try {
      final authRepository = _ref.read(authRepositoryProvider);
      _subscription = authRepository.authStateChanges.listen((_) {
        notifyListeners();
      });
    } catch (e) {
      // If auth repository is not available during initialization,
      // we'll handle it gracefully and the getters will return safe defaults
    }
  }

  bool get isAuthenticated {
    try {
      final authRepository = _ref.read(authRepositoryProvider);
      return authRepository.isSignedIn;
    } catch (e) {
      return false;
    }
  }

  bool get isEmailVerified {
    try {
      final authRepository = _ref.read(authRepositoryProvider);
      return authRepository.isEmailVerified;
    } catch (e) {
      return false;
    }
  }

  User? get currentUser {
    try {
      final authRepository = _ref.read(authRepositoryProvider);
      return authRepository.currentUser;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
