import '../models/error_metadata.dart';
import 'base_exceptions.dart';

/// A static utility to easily throw semantic exceptions throughout the app.
class ErrorThrower {
  ErrorThrower._();

  /// Throws a [ServerException].
  static Never server(ErrorMetadata metadata, {required String message}) {
    throw ServerException(message: message, metadata: metadata);
  }

  /// Throws an [AuthException].
  static Never auth(ErrorMetadata metadata, {required String message}) {
    throw AuthException(message: message, metadata: metadata);
  }

  /// Throws a [LocalDatabaseException].
  static Never db(ErrorMetadata metadata, {required String message}) {
    throw LocalDatabaseException(message: message, metadata: metadata);
  }

  /// Throws a [SyncException].
  static Never sync(ErrorMetadata metadata, {required String message}) {
    throw SyncException(message: message, metadata: metadata);
  }

  /// Throws an [OfflineException].
  static Never offline(ErrorMetadata metadata, {required String message}) {
    throw OfflineException(message: message, metadata: metadata);
  }

  /// Throws an [UnknownException].
  static Never unknown(
    ErrorMetadata metadata, {
    String message = 'An unknown error occurred.',
  }) {
    throw UnknownException(message: message, metadata: metadata);
  }
}
