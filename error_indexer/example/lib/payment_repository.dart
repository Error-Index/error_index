import 'package:error_indexer/error_indexer.dart';

@ErrorScope('PAY_REPO')
class PaymentRepository {
  @ErrorPoint('GET_METHODS')
  void getMethods() {}

  @ErrorPoint('PROCESS_PAY')
  void processPayment() {}
}
