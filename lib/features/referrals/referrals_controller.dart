import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repositories/referral_repository.dart';
import '../../data/models/referral_models.dart';

class ReferralsController extends GetxController {
  ReferralsController(this.repo);
  final IReferralRepository repo;
  final items = <ReferralItem>[].obs;

  String get link => repo.inviteLink();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    items.value = await repo.list();
  }

  void share() => Share.share('Join InFly: $link');
}
