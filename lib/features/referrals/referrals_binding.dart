import 'package:get/get.dart';
import '../../data/repositories/referral_repository.dart';
import 'referrals_controller.dart';

class ReferralsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralsController>(() => ReferralsController(Get.find<IReferralRepository>()));
  }
}
