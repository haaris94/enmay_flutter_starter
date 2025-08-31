# Riverpod v2.x Best Practices - Claude Instructions

## CRITICAL: Always Follow These Rules

1. **Use `Ref ref` parameter** - Never use `ProviderRef`, `FutureProviderRef`, etc.
2. **Avoid deprecated providers** - Never use `StateProvider` or `StateNotifierProvider`
3. **Add `part` directive** - Always include `part 'filename.g.dart';` when using `@riverpod`
4. **Use `.notifier` for methods** - Access NotifierProvider methods via `.notifier`

## Provider Selection Guide

**Simple immutable values** → `Provider`
**One-time async operations** → `FutureProvider`  
**Continuous data streams** → `StreamProvider`
**Mutable state** → `NotifierProvider`
**Mutable async state** → `AsyncNotifierProvider`

## Code Templates

### Provider (Immutable)

```dart
@riverpod
String appTitle(Ref ref) => 'My App';

@riverpod
ApiService apiService(Ref ref) => ApiService();
```

### FutureProvider (Async)

```dart
@riverpod
Future<Weather> weather(Ref ref) async {
  final api = ref.watch(apiServiceProvider);
  return await api.fetchWeather();
}
```

### StreamProvider (Streams)

```dart
@riverpod
Stream<int> counter(Ref ref) async* {
  int count = 0;
  while (true) {
    yield count++;
    await Future.delayed(const Duration(seconds: 1));
  }
}
```

### NotifierProvider (Mutable)

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
}

// Usage:
ref.read(counterProvider.notifier).increment();
```

### AsyncNotifierProvider (Async Mutable)

```dart
@riverpod
class UsersNotifier extends _$UsersNotifier {
  @override
  Future<List<User>> build() async => await fetchUsers();
  
  Future<void> addUser(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await saveUser(user);
      return [...state.requireValue, user];
    });
  }
}
```

## AsyncValue Handling

**Always use `.when()`** for async providers:

```dart
final users = ref.watch(usersProvider);
return users.when(
  data: (users) => UserList(users),
  error: (error, stack) => ErrorWidget(error.toString()),
  loading: () => const CircularProgressIndicator(),
);
```

## Performance Optimizations

**Use `ref.select()`** to prevent unnecessary rebuilds:

```dart
// ✅ Good - only rebuilds when username changes
final username = ref.watch(userProvider.select((user) => user.username));

// ❌ Rebuilds when any user property changes
final user = ref.watch(userProvider);
```

## New Features (Experimental)

### Mutations - For loading states in operations

```dart
final addTodo = Mutation<Todo>();

// Listen
final state = ref.watch(addTodo);
switch (state) {
  case MutationPending(): return CircularProgressIndicator();
  case MutationError(): return Text('Error: ${state.error}');
  case MutationSuccess(): return Text('Success!');
  case MutationIdle(): return Text('Ready');
}

// Trigger
addTodo.run(ref, (tsx) async {
  final notifier = tsx.get(todoNotifierProvider);
  return await notifier.addTodo('New task');
});
```

### Persistence - For offline storage

```dart
// Setup
final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), 'app.db'));
});

// Use in NotifierProvider/AsyncNotifierProvider
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    persist(
      ref.watch(storageProvider.future),
      key: 'todo_list',
      encode: (todos) => todos.map((t) => {'task': t.task}).toList(),
      decode: (json) => (json as List).map((t) => Todo(task: t['task'])).toList(),
    );
    return fetchTodos();
  }
}
```

### Automatic Retry - Customization

```dart
// Custom retry logic
Duration? customRetry(int retryCount, Object error) {
  if (retryCount >= 5) return null;
  if (error is ProviderException) return null;
  return Duration(milliseconds: 200 * (1 << retryCount));
}

// Apply globally
ProviderScope(retry: customRetry, child: MyApp())

// Or per provider
@riverpod
Future<Data> myProvider(Ref ref) async {
  ref.retry = customRetry;
  return await fetchData();
}
```

## Widget Integration Patterns

```dart
// ConsumerWidget (most common)
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Text(user.name);
  }
}

// Consumer (for specific widgets)
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  },
)
```

## Testing Override Pattern

```dart
ProviderScope(
  overrides: [
    apiServiceProvider.overrideWithValue(mockApiService),
    storageProvider.overrideWith((ref) => Storage.inMemory()),
  ],
  child: MyApp(),
)
```

## When to Use What

- **Loading states in forms/buttons** → Mutations
- **Offline data storage** → Persistence  
- **Network retry customization** → Custom retry
- **Performance optimization** → ref.select()
- **Simple values/services** → Provider
- **One-time API calls** → FutureProvider
- **Real-time data** → StreamProvider
- **User interaction state** → NotifierProvider
- **Async user interaction** → AsyncNotifierProvider
