import 'package:get/get.dart';
import '../../data/repositories/wallet_repository.dart';
import 'wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController(Get.find<IWalletRepository>()));
  }
}
