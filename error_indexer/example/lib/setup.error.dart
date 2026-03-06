// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:error_indexer/error_indexer.dart';

abstract class AuthRepositoryErrorIndex {
  AuthRepositoryErrorIndex._();
  static const login = ErrorMetadata(
    scopeCode: 'AUTH_REPO',
    pointCode: 'LOGIN',
    className: 'AuthRepository',
    methodName: 'login',
  );

  static const logout = ErrorMetadata(
    scopeCode: 'AUTH_REPO',
    pointCode: 'LOGOUT',
    className: 'AuthRepository',
    methodName: 'logout',
  );

}

abstract class PaymentRepositoryErrorIndex {
  PaymentRepositoryErrorIndex._();
  static const getMethods = ErrorMetadata(
    scopeCode: 'PAY_REPO',
    pointCode: 'GET_METHODS',
    className: 'PaymentRepository',
    methodName: 'getMethods',
  );

  static const processPayment = ErrorMetadata(
    scopeCode: 'PAY_REPO',
    pointCode: 'PROCESS_PAY',
    className: 'PaymentRepository',
    methodName: 'processPayment',
  );

}

