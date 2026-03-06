import '../models/error_metadata.dart';

/// The base exception class containing shared properties.
abstract class BaseException implements Exception {
  /// A human-readable message describing the error.
  final String message;

  /// The base HTTP-like or domain-level code (e.g., 'E500', 'E401').
  final String baseCode;

  /// The generated error metadata linking this exception to a specific point in code.
  final ErrorMetadata metadata;

  const BaseException({
    required this.message,
    required this.baseCode,
    required this.metadata,
  });

  /// The complete error code formatted for logging or user display.
  String get errorCode => '$baseCode-${metadata.fullErrorCode}';

  @override
  String toString() {
    return '$runtimeType [$errorCode]: $message';
  }
}

/// Represents a server or API-related exception.
class ServerException extends BaseException {
  const ServerException({
    required super.message,
    super.baseCode = 'E500',
    required super.metadata,
  });
}

/// Represents an authentication or authorization exception.
class AuthException extends BaseException {
  const AuthException({
    required super.message,
    super.baseCode = 'E401',
    required super.metadata,
  });
}

/// Represents a local database or storage exception.
class LocalDatabaseException extends BaseException {
  const LocalDatabaseException({
    required super.message,
    super.baseCode = 'EDB01',
    required super.metadata,
  });
}

/// Represents a synchronization error.
class SyncException extends BaseException {
  const SyncException({
    required super.message,
    super.baseCode = 'ESYNC',
    required super.metadata,
  });
}

/// Represents a network or offline scenario exception.
class OfflineException extends BaseException {
  const OfflineException({
    required super.message,
    super.baseCode = 'EOFF',
    required super.metadata,
  });
}

/// Represents an unknown or unhandled logical exception.
class UnknownException extends BaseException {
  const UnknownException({
    super.message = 'An unknown error occurred.',
    super.baseCode = 'EUNKN',
    required super.metadata,
  });
}
