import 'package:get/get.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/utils/validators.dart';
import '../../core/services/notification_service.dart';
import '../../config/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this.repo);
  final IAuthRepository repo;

  final phone = ''.obs;
  final name = ''.obs;
  final otp = ''.obs;
  final loading = false.obs;

  Future<void> sendLoginOtp() async {
    if (!Validators.isPhone(phone.value)) { 
      NotificationService.showError('Invalid', 'Enter 10-digit phone'); 
      return; 
    }
    loading.value = true;
    await repo.login(LoginRequest(phone: phone.value));
    loading.value = false;
    NotificationService.showOtpSent(phone.value);
    Get.toNamed(Routes.otp);
  }

  Future<void> register() async {
    if (name.value.isEmpty || !Validators.isPhone(phone.value)) { 
      NotificationService.showError('Invalid', 'Name & 10-digit phone required'); 
      return; 
    }
    loading.value = true;
    await repo.register(RegisterRequest(name: name.value, phone: phone.value));
    loading.value = false;
    NotificationService.showRegistrationSuccess(name.value);
    Get.toNamed(Routes.otp);
  }

  Future<void> verifyOtp() async {
    if (!Validators.isOtp(otp.value)) { 
      NotificationService.showError('Invalid', 'Enter 6-digit OTP'); 
      return; 
    }
    loading.value = true;
    final ok = await repo.verifyOtp(OtpVerifyRequest(otp: otp.value));
    loading.value = false;
    if (ok) {
      NotificationService.showLoginSuccess(phone.value);
      // Get.offAllNamed(Routes.dashboard);
      Get.offAllNamed(Routes.shell);
    } else {
      NotificationService.showError('Error', 'Incorrect OTP');
    }
  }
}
