import 'package:get/get.dart';
import '../../data/models/finance_models.dart';
import '../../data/repositories/finance_repository.dart';
import '../../core/services/notification_service.dart';

class FinanceController extends GetxController {
  FinanceController(this.repository);
  final FinanceRepository repository;

  final summary = Rxn<WalletSummary>();
  final transactions = <Transaction>[].obs;
  final earningStats = Rxn<EarningStats>();
  final isLoading = false.obs;
  final selectedFilter = TransactionType.values.obs;
  final selectedPeriod = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadSummary(),
        loadTransactions(),
        loadEarningStats(),
      ]);
    } catch (e) {
      NotificationService.showError('Error', 'Failed to load finance data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSummary() async {
    try {
      summary.value = await repository.getWalletSummary();
    } catch (e) {
      print('Error loading summary: $e');
    }
  }

  Future<void> loadTransactions() async {
    try {
      transactions.value = await repository.getTransactions();
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  Future<void> loadEarningStats() async {
    try {
      earningStats.value = await repository.getEarningStats();
    } catch (e) {
      print('Error loading earning stats: $e');
    }
  }

  void filterTransactions(TransactionType? type) {
    if (type == null) {
      selectedFilter.value = TransactionType.values;
    } else {
      selectedFilter.value = [type];
    }
  }

  void filterByPeriod(String period) {
    selectedPeriod.value = period;
    // Implement period filtering logic
  }

  List<Transaction> get filteredTransactions {
    if (selectedFilter.value == TransactionType.values) {
      return transactions;
    }
    return transactions.where((txn) => selectedFilter.value.contains(txn.type)).toList();
  }

  Future<void> refreshData() async {
    await loadData();
    NotificationService.showInfo('Refreshed', 'Finance data updated');
  }

  Future<void> withdrawFunds(double amount) async {
    try {
      isLoading.value = true;
      await repository.withdrawFunds(amount);
      await loadSummary();
      await loadTransactions();
      NotificationService.showSuccess('Withdrawal Requested', 'Your withdrawal request has been submitted');
    } catch (e) {
      NotificationService.showError('Error', 'Failed to process withdrawal');
    } finally {
      isLoading.value = false;
    }
  }
}
