import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'config/env.dart';
import 'core/services/api_client.dart';
import 'core/services/secure_store.dart';
import 'core/services/whatsapp_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/kyc_repository.dart';
import 'data/repositories/video_repository.dart';
import 'data/repositories/referral_repository.dart';
import 'data/repositories/finance_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core singletons
    Get.put<ApiClient>(ApiClient(baseUrl: Env.waBaseUrl), permanent: true);

    // Secure storage & services
    Get.put<SecureStore>(SecureStore(), permanent: true);
    Get.put<WhatsAppService>(
      WhatsAppService(Dio()), // ✅ supply a fresh Dio instance
      permanent: true,
    );

    // Repositories
    Get.put<KycRepository>(KycRepository(), permanent: true);
    Get.put<IVideoRepository>(VideoRepository(Get.find()), permanent: true);
    Get.put<IReferralRepository>(ReferralRepository(Get.find()), permanent: true);
    Get.put<FinanceRepository>(FinanceRepositoryImpl(Get.find()), permanent: true);

    // Auth repository now has everything it needs
    Get.put<IAuthRepository>(
      AuthRepository(
        Get.find<ApiClient>(),
        Get.find<SecureStore>(),
        Get.find<WhatsAppService>(),
      ),
      permanent: true,
    );
  }
}
