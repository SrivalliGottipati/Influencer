import '../../config/env.dart';
import '../../core/services/api_client.dart';
import '../models/finance_models.dart';

abstract class FinanceRepository {
  Future<WalletSummary> getWalletSummary();
  Future<List<Transaction>> getTransactions();
  Future<EarningStats> getEarningStats();
  Future<void> withdrawFunds(double amount);
  Future<void> depositFunds(double amount);
}

class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this.client);
  final ApiClient client;

  @override
  Future<WalletSummary> getWalletSummary() async {
    if (Env.useMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return WalletSummary.mock();
    }
    
    try {
      final response = await client.dio.get('${Env.baseUrl}/wallet/summary');
      return WalletSummary.fromJson(response.data);
    } catch (e) {
      // Return mock data on error
      return WalletSummary.mock();
    }
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    if (Env.useMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return List.generate(20, (index) => Transaction.mock(index));
    }
    
    try {
      final response = await client.dio.get('${Env.baseUrl}/wallet/transactions');
      return (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      // Return mock data on error
      return List.generate(20, (index) => Transaction.mock(index));
    }
  }

  @override
  Future<EarningStats> getEarningStats() async {
    if (Env.useMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return EarningStats.mock();
    }
    
    try {
      final response = await client.dio.get('${Env.baseUrl}/wallet/earnings');
      return EarningStats(
        totalEarnings: (response.data['totalEarnings'] as num).toDouble(),
        videoEarnings: (response.data['videoEarnings'] as num).toDouble(),
        referralEarnings: (response.data['referralEarnings'] as num).toDouble(),
        bonusEarnings: (response.data['bonusEarnings'] as num).toDouble(),
        monthlyEarnings: (response.data['monthlyEarnings'] as num).toDouble(),
        weeklyEarnings: (response.data['weeklyEarnings'] as num).toDouble(),
        todayEarnings: (response.data['todayEarnings'] as num).toDouble(),
        totalVideos: response.data['totalVideos'],
        totalReferrals: response.data['totalReferrals'],
        averageEarningPerVideo: (response.data['averageEarningPerVideo'] as num).toDouble(),
        averageEarningPerReferral: (response.data['averageEarningPerReferral'] as num).toDouble(),
      );
    } catch (e) {
      // Return mock data on error
      return EarningStats.mock();
    }
  }

  @override
  Future<void> withdrawFunds(double amount) async {
    if (Env.useMocks) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    
    await client.dio.post('${Env.baseUrl}/wallet/withdraw', data: {
      'amount': amount,
    });
  }

  @override
  Future<void> depositFunds(double amount) async {
    if (Env.useMocks) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    
    await client.dio.post('${Env.baseUrl}/wallet/deposit', data: {
      'amount': amount,
    });
  }
}
