import '../../config/env.dart';
import '../../core/services/api_client.dart';
import '../models/referral_models.dart';

abstract class IReferralRepository {
  Future<List<ReferralItem>> list();
  String inviteLink();
}

class ReferralRepository implements IReferralRepository {
  ReferralRepository(this.client);
  final ApiClient client;

  @override
  Future<List<ReferralItem>> list() async {
    if (Env.useMocks) {
      return List.generate(6, (i) => ReferralItem(name: 'User #${i + 1}', date: '28 Aug 2025', amount: 50));
    }
    final res = await client.dio.get(Env.epReferrals);
    return (res.data as List).map((e) => ReferralItem(name: e['name'], date: e['date'], amount: e['amount'])).toList();
  }

  @override
  String inviteLink() => 'https://infly.app/invite/ABC123'; // TODO: from API
}
