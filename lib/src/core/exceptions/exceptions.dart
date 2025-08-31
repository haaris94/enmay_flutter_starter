/// Base class for exceptions originating from data sources or external services.
/// These are typically caught by Repositories and mapped to [Failure] types.
class DataSourceException implements Exception {
  final String? message;
  final dynamic originalException;
  final StackTrace? stackTrace;

  DataSourceException({this.message, this.originalException, this.stackTrace});

  @override
  String toString() {
    return 'DataSourceException: ${message ?? originalException?.toString() ?? "Unknown data source error"}';
  }
}

/// Exception indicating an error during communication with a remote server.
class ServerException extends DataSourceException {
  final int? statusCode;

  ServerException({super.message, this.statusCode, super.originalException, super.stackTrace});

  @override
  String toString() {
    final status = statusCode != null ? ' (Status: $statusCode)' : '';
    return 'ServerException: ${message ?? originalException?.toString() ?? "Unknown server error"}$status';
  }
}

/// Exception indicating an error during interaction with local cache/storage.
class CacheException extends DataSourceException {
  CacheException({super.message, super.originalException, super.stackTrace});

  @override
  String toString() {
    return 'CacheException: ${message ?? originalException?.toString() ?? "Unknown cache error"}';
  }
}

/// Exception indicating invalid data was provided or received.
class InvalidDataException extends DataSourceException {
  InvalidDataException({super.message, super.originalException, super.stackTrace});

  @override
  String toString() {
    return 'InvalidDataException: ${message ?? originalException?.toString() ?? "Invalid data error"}';
  }
}

/// Exception indicating a required permission was denied.
class PermissionDeniedException extends DataSourceException {
  final String? permission;

  PermissionDeniedException({super.message, this.permission, super.originalException, super.stackTrace});

  @override
  String toString() {
    final perm = permission != null ? ' (Permission: $permission)' : '';
    return 'PermissionDeniedException: ${message ?? originalException?.toString() ?? "Permission denied"}$perm';
  }
}
