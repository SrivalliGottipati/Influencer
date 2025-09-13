import 'package:get/get.dart';
import '../../data/repositories/finance_repository.dart';
import 'finance_controller.dart';

class FinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinanceRepository>(() => FinanceRepositoryImpl(Get.find()));
    Get.lazyPut<FinanceController>(() => FinanceController(Get.find()));
  }
}
