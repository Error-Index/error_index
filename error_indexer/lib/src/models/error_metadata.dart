/// Represents the generated metadata for a specific error point.
class ErrorMetadata {
  /// The scope code (from @ErrorScope).
  final String scopeCode;

  /// The point code (from @ErrorPoint).
  final String pointCode;

  /// The class name where the error point is defined.
  final String className;

  /// The method name where the error point is defined.
  final String methodName;

  const ErrorMetadata({
    required this.scopeCode,
    required this.pointCode,
    required this.className,
    required this.methodName,
  });

  /// The computed full error code (combining scope and point).
  String get fullErrorCode => '$scopeCode-$pointCode';

  @override
  String toString() => fullErrorCode;
}
