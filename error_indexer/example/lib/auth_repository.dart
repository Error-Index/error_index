import 'package:error_indexer/error_indexer.dart';

@ErrorScope('AUTH_REPO')
class AuthRepository {
  @ErrorPoint('LOGIN')
  void login() {}

  @ErrorPoint('LOGOUT')
  void logout() {}
}
