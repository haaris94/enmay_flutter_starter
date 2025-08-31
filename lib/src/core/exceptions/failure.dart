enum ErrorType { network, authentication, validation, storage, externalApi, unknown }

class Failure {
  final String title;
  final String message;
  final ErrorType type;
  final String? actionHint;

  const Failure({required this.title, required this.message, required this.type, this.actionHint});
}
