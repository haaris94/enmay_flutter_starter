import 'package:enmay_flutter_starter/src/core/logging/console_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  // Simulate initialization delay for demonstration
  await Future.delayed(const Duration(milliseconds: 800));
  return SharedPreferences.getInstance();
}