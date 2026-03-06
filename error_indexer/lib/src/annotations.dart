/// Used to annotate a class (e.g., a Repository or Module) holding error points.
class ErrorScope {
  /// The module or repository level code (e.g., 'PAY_REPO').
  final String code;

  const ErrorScope(this.code);
}

/// Used to annotate a method (e.g., a specific API call or operation).
class ErrorPoint {
  /// The specific operation level code (e.g., 'GET_METHODS').
  final String code;

  const ErrorPoint(this.code);
}

/// Used to annotate a setup function/class to trigger error registry generation.
/// The builder will generate `<original_file>.error.dart` in the same directory.
class ErrorIndexInit {
  /// The suffix appended to the generated class names.
  /// E.g., if classSuffix is 'ErrorIndex' and target is `AuthRepository`,
  /// the generated class will be `AuthRepositoryErrorIndex`.
  final String classSuffix;

  const ErrorIndexInit({this.classSuffix = 'ErrorIndex'});
}
