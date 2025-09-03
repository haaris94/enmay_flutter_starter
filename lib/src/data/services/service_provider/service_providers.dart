import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog_service.dart';

part 'service_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async => SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
DialogService dialogService(Ref ref, GlobalKey<NavigatorState> navigatorKey) {
  return DialogService(navigatorKey: navigatorKey);
}