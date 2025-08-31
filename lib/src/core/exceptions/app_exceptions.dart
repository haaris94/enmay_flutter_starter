class StartupException implements Exception {
  const StartupException(this.message);
  final String message;

  @override
  String toString() => message;
}
