enum ErrorType { 
  network, 
  authentication, 
  validation, 
  storage, 
  externalApi, 
  unknown,
  emailNotVerified,
  userDisabled,
  tooManyRequests,
  providerAlreadyLinked,
  weakPassword,
  operationNotAllowed
}

class Failure {
  final String title;
  final String message;
  final ErrorType type;

  const Failure({required this.title, required this.message, required this.type});
}
