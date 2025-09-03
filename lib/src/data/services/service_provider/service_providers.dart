import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async => SharedPreferences.getInstance();