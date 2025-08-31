# Riverpod v2.x Architecture for Production Apps

## 🏗️ Core Architecture Layers

📱 UI Layer (Widgets)
    ↕️
🔄 Feature Providers (Business Logic)
    ↕️
🏪 Core Providers (Infrastructure)
    ↕️
🔌 External Services (Firebase, APIs, etc.)

## 📁 Project Structure

```bash
lib/
├── core/
│   ├── providers/
│   │   ├── app_providers.dart          # Global app state
│   │   ├── storage_providers.dart      # Offline storage
│   │   ├── network_providers.dart      # Connectivity & HTTP
│   │   ├── firebase_providers.dart     # Firebase services
│   │   ├── error_providers.dart        # Error handling
│   │   └── i18n_providers.dart         # Internationalization
│   ├── models/
│   │   ├── app_error.dart              # Standardized errors
│   │   ├── app_state.dart              # App-wide state
│   │   └── network_state.dart          # Network status
│   ├── exceptions/
│   │   └── app_exceptions.dart         # Custom exceptions
│   └── constants/
│       └── storage_keys.dart           # Storage constants
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   ├── auth_providers.dart     # Auth state & operations
│   │   │   └── auth_mutations.dart     # Login/logout operations
│   │   ├── models/
│   │   │   └── user.dart
│   │   └── widgets/
│   │       ├── login_screen.dart
│   │       └── auth_wrapper.dart
│   ├── products/
│   │   ├── providers/
│   │   │   ├── products_providers.dart
│   │   │   └── products_mutations.dart
│   │   ├── models/
│   │   │   └── product.dart
│   │   └── widgets/
│   │       ├── products_screen.dart
│   │       └── product_card.dart
│   └── cart/
│       ├── providers/
│       │   ├── cart_providers.dart
│       │   └── cart_mutations.dart
│       ├── models/
│       │   └── cart.dart
│       └── widgets/
│           └── cart_screen.dart
├── shared/
│   ├── widgets/
│   │   ├── error_widget.dart           # Standardized error UI
│   │   ├── loading_widget.dart         # Loading states
│   │   └── offline_banner.dart         # Offline indicator
│   └── utils/
│       ├── connectivity_utils.dart
│       └── storage_utils.dart
└── main.dart
```

## 🏪 Core Infrastructure Providers

### Storage Provider (Offline First)

```dart
// core/providers/storage_providers.dart
@riverpod
Future<Storage<String, dynamic>> appStorage(Ref ref) async {
  return JsonSqFliteStorage.open(
    join(await getDatabasesPath(), 'app_v1.db'),
  );
}

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}
```

### Network Provider (Connectivity + HTTP)

```dart
// core/providers/network_providers.dart
@riverpod
Connectivity connectivity(Ref ref) => Connectivity();

@riverpod
Stream<ConnectivityResult> connectivityStream(Ref ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
}

@riverpod
bool isOnline(Ref ref) {
  final connectivity = ref.watch(connectivityStreamProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true, // Assume online during loading
    error: (_, __) => true,
  );
}

@riverpod
Dio httpClient(Ref ref) {
  final dio = Dio();
  
  // Base configuration
  dio.options = BaseOptions(
    baseUrl: 'https://api.yourapp.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  );
  
  // Add interceptors
  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
    QueuedInterceptor(), // Handle token refresh
    RetryInterceptor(dio: dio, retries: 3),
  ]);
  
  // Auto-retry configuration
  ref.retry = (retryCount, error) {
    if (retryCount >= 3) return null;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return null; // Don't retry client errors
      }
    }
    return Duration(milliseconds: 500 * (1 << retryCount));
  };
  
  return dio;
}
```

### Firebase Provider

```dart
// core/providers/firebase_providers.dart
@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
FirebaseMessaging firebaseMessaging(Ref ref) => FirebaseMessaging.instance;

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}
```

### Error Handling Provider

```dart
// core/providers/error_providers.dart
@riverpod
class GlobalErrorHandler extends _$GlobalErrorHandler {
  @override
  List<AppError> build() => [];
  
  void handleError(Object error, StackTrace? stackTrace) {
    final appError = AppError.fromException(error, stackTrace);
    
    // Log error (Crashlytics, etc.)
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // Add to error list for UI consumption
    state = [...state, appError];
    
    // Auto-remove after 5 seconds
    Timer(const Duration(seconds: 5), () {
      removeError(appError.id);
    });
  }
  
  void removeError(String errorId) {
    state = state.where((error) => error.id != errorId).toList();
  }
  
  void clearAll() => state = [];
}

// Custom error wrapper for AsyncValue
extension AsyncValueErrorHandling<T> on AsyncValue<T> {
  AsyncValue<T> handleError(Ref ref) {
    return when(
      data: (data) => AsyncValue.data(data),
      error: (error, stackTrace) {
        ref.read(globalErrorHandlerProvider.notifier).handleError(error, stackTrace);
        return AsyncValue.error(error, stackTrace);
      },
      loading: () => const AsyncValue.loading(),
    );
  }
}
```

### Internationalization Provider

```dart
// core/providers/i18n_providers.dart
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Load saved locale or use system locale
    _loadSavedLocale();
    return const Locale('en', 'US');
  }
  
  Future<void> setLocale(Locale locale) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('locale', locale.toString());
    state = locale;
  }
  
  void _loadSavedLocale() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final savedLocale = prefs.getString('locale');
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      state = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    }
  }
}
```

## 🎯 Feature Provider Pattern

### Authentication Feature

```dart
// features/auth/providers/auth_providers.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // Enable persistence for offline auth state
    persist(
      ref.watch(appStorageProvider.future),
      key: StorageKeys.currentUser,
      encode: (user) => user?.toJson(),
      decode: (json) => json != null ? User.fromJson(json) : null,
    );
    
    // Listen to Firebase auth changes
    final authStream = ref.watch(authStateChangesProvider);
    return authStream.when(
      data: (firebaseUser) => firebaseUser != null 
          ? User.fromFirebaseUser(firebaseUser)
          : null,
      loading: () => null,
      error: (_, __) => null,
    );
  }
  
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(firebaseAuthProvider).signOut();
      return null;
    });
  }
}

// features/auth/providers/auth_mutations.dart
@riverpod
class LoginMutation extends _$LoginMutation {
  @override
  AsyncValue<User?> build() => const AsyncValue.data(null);
  
  Future<User> execute(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await AsyncValue.guard(() async {
      final credential = await ref.read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      
      if (credential.user == null) {
        throw AuthException('Login failed');
      }
      
      return User.fromFirebaseUser(credential.user!);
    });
    
    state = result;
    
    if (result.hasError) {
      ref.read(globalErrorHandlerProvider.notifier)
          .handleError(result.error!, result.stackTrace);
    }
    
    return result.requireValue;
  }
}
```

### Products Feature (with Offline-First)

```dart
// features/products/providers/products_providers.dart
@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  Future<List<Product>> build() async {
    // Enable offline persistence
    persist(
      ref.watch(appStorageProvider.future),
      key: StorageKeys.products,
      encode: (products) => products.map((p) => p.toJson()).toList(),
      decode: (json) => (json as List).map((p) => Product.fromJson(p)).toList(),
    );
    
    return _fetchProducts();
  }
  
  Future<List<Product>> _fetchProducts() async {
    final isOnline = ref.read(isOnlineProvider);
    
    if (!isOnline) {
      // Return cached data when offline
      throw const OfflineException('No internet connection');
    }
    
    final firestore = ref.read(firestoreProvider);
    final snapshot = await firestore.collection('products').get();
    
    return snapshot.docs
        .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchProducts);
  }
}

// features/products/providers/products_mutations.dart
@riverpod
class AddProductMutation extends _$AddProductMutation {
  @override
  AsyncValue<Product?> build() => const AsyncValue.data(null);
  
  Future<Product> execute(CreateProductRequest request) async {
    state = const AsyncValue.loading();
    
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      final docRef = await firestore.collection('products').add(request.toJson());
      final doc = await docRef.get();
      
      final product = Product.fromJson({...doc.data()!, 'id': doc.id});
      
      // Optimistically update local state
      final currentProducts = ref.read(productsNotifierProvider).valueOrNull ?? [];
      ref.read(productsNotifierProvider.notifier).state = 
          AsyncValue.data([...currentProducts, product]);
      
      return product;
    });
    
    state = result.handleError(ref);
    return result.requireValue;
  }
}
```

## 🎨 UI Integration Patterns

### Screen with Error Handling & Loading

```dart
// features/products/widgets/products_screen.dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsNotifierProvider);
    final isOnline = ref.watch(isOnlineProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.products),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productsNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline banner
          if (!isOnline) const OfflineBanner(),
          
          // Global error display
          const GlobalErrorDisplay(),
          
          // Main content
          Expanded(
            child: products.when(
              data: (products) => ProductsList(products: products),
              error: (error, stack) => ErrorWidget(
                error: error,
                onRetry: () => ref.read(productsNotifierProvider.notifier).refresh(),
              ),
              loading: () => const LoadingWidget(),
            ),
          ),
        ],
      ),
      floatingActionButton: const AddProductFAB(),
    );
  }
}
```

### Shared Error Widget

```dart
// shared/widgets/error_widget.dart
class AppErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  
  const AppErrorWidget({
    Key? key,
    required this.error,
    this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final errorMessage = _getErrorMessage(context, error);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ],
      ),
    );
  }
  
  String _getErrorMessage(BuildContext context, Object error) {
    if (error is OfflineException) {
      return context.l10n.offlineMessage;
    } else if (error is AuthException) {
      return context.l10n.authError;
    } else if (error is DioException) {
      return context.l10n.networkError;
    }
    return context.l10n.genericError;
  }
}
```

## 🧪 Testing Strategy

### Provider Testing

```dart
// test/features/auth/providers/auth_providers_test.dart
void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(MockFirebaseAuth()),
          appStorageProvider.overrideWith((ref) => Storage.inMemory()),
        ],
      );
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('should start with null user', () {
      final auth = container.read(authNotifierProvider);
      expect(auth, const AsyncValue<User?>.data(null));
    });
    
    test('should sign out user', () async {
      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signOut();
      
      final auth = container.read(authNotifierProvider);
      expect(auth.valueOrNull, isNull);
    });
  });
}
```

## 📋 Main App Setup

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  
  // Global error handling
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  
  runApp(
    ProviderScope(
      // Global retry policy
      retry: (retryCount, error) {
        if (retryCount >= 3) return null;
        if (error is AuthException) return null;
        return Duration(milliseconds: 200 * (1 << retryCount));
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    
    return MaterialApp(
      title: 'My App',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthWrapper(),
    );
  }
}
```

## 🔄 Development Workflow

1. **Feature Development**:
   - Create models in `features/[feature]/models/`
   - Create providers in `features/[feature]/providers/`
   - Create UI in `features/[feature]/widgets/`
   - Write tests in `test/features/[feature]/`

2. **Code Generation**: Run `dart run build_runner build` after adding `@riverpod`

3. **Error Handling**: All errors flow through `GlobalErrorHandler`

4. **Offline Support**: Use `persist()` for critical data

5. **Testing**: Mock core providers, test feature providers in isolation

## 🎯 Key Benefits

- **Offline-First**: Built-in persistence and connectivity handling
- **Professional Error Handling**: Centralized, user-friendly error management
- **Type-Safe**: Full compile-time safety with code generation
- **Testable**: Easy mocking and testing with provider overrides
- **Scalable**: Clear separation of concerns and feature isolation
- **Team-Friendly**: Consistent patterns and clear structure
- **Performance**: Built-in caching, lazy loading, and optimizations
- **Firebase Ready**: Seamless Firebase integration
- **i18n Support**: Built-in internationalization
