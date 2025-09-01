import 'package:get/get.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../data/models/wallet_models.dart';

class WalletController extends GetxController {
  WalletController(this.repo);
  final IWalletRepository repo;
  final summary = Rxn<WalletSummary>();
  final txns = <WalletTxn>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    summary.value = await repo.summary();
    txns.value = await repo.txns();
  }
}
