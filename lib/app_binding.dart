import 'package:get/get.dart';
import 'core/services/api_client.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/kyc_repository.dart';
import 'data/repositories/video_repository.dart';
import 'data/repositories/referral_repository.dart';
import 'data/repositories/wallet_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core singletons
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Repositories
    Get.put<IAuthRepository>(AuthRepository(Get.find()), permanent: true);
    // Get.put<IKycRepository>(KycRepository(Get.find()), permanent: true);
    Get.put<KycRepository>(KycRepository(), permanent: true);
    Get.put<IVideoRepository>(VideoRepository(Get.find()), permanent: true);
    Get.put<IReferralRepository>(ReferralRepository(Get.find()), permanent: true);
    Get.put<IWalletRepository>(WalletRepository(Get.find()), permanent: true);
  }
}
