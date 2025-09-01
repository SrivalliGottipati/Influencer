import '../../config/env.dart';
import '../../core/services/api_client.dart';
import '../models/wallet_models.dart';

abstract class IWalletRepository {
  Future<WalletSummary> summary();
  Future<List<WalletTxn>> txns();
}

class WalletRepository implements IWalletRepository {
  WalletRepository(this.client);
  final ApiClient client;

  @override
  Future<WalletSummary> summary() async {
    if (Env.useMocks) return WalletSummary.mock();
    final res = await client.dio.get(Env.epWallet);
    return WalletSummary(balance: (res.data['balance'] as num).toDouble());
  }

  @override
  Future<List<WalletTxn>> txns() async {
    if (Env.useMocks) {
      return List.generate(8, (i) => WalletTxn(title: i % 2 == 0 ? 'Referral Bonus' : 'Payout', date: '28 Aug 2025', amount: i % 2 == 0 ? 50 : -500));
    }
    final res = await client.dio.get('${Env.epWallet}/txns');
    return (res.data as List).map((e) => WalletTxn(title: e['title'], date: e['date'], amount: (e['amount'] as num).toDouble())).toList();
  }
}
