import 'package:get/get.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/utils/validators.dart';
import '../../config/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this.repo);
  final IAuthRepository repo;

  final phone = ''.obs;
  final name = ''.obs;
  final email = ''.obs;
  final otp = ''.obs;
  final loading = false.obs;

  final countryCode = '91'.obs;

  void _snack(String title, String msg) =>
      Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);

  Future<void> sendLoginOtp() async {
    if (!Validators.isPhone(phone.value)) {
      _snack('Invalid', 'Enter 10-digit phone');
      return;
    }

    loading.value = true;
    try {
      final fullPhone = "${countryCode.value}${phone.value}";

      print("➡ sendLoginOtp: Checking existence for $fullPhone");
      final exists = await repo.checkUserExists(fullPhone);
      print("🔎 sendLoginOtp: checkUserExists returned $exists");

      if (!exists) {
        _snack('Error', 'No account found. Please register first.');
        loading.value = false;
        return;
      }

      await repo.login(LoginRequest(phone: fullPhone));
      _snack('OTP Sent', 'OTP sent to $fullPhone');
      Get.toNamed(Routes.otp);
    } catch (e) {
      print("❌ sendLoginOtp error: $e");
      _snack('Error', 'Failed to send OTP');
    } finally {
      loading.value = false;
    }
  }


  Future<void> register() async {
    if (!Validators.nonEmpty(name.value)) {
      _snack('Invalid', 'Name is required');
      return;
    }
    if (!Validators.isPhone(phone.value)) {
      _snack('Invalid', 'Enter 10-digit phone');
      return;
    }
    if (!Validators.isEmail(email.value)) {
      _snack('Invalid', 'Enter a valid email');
      return;
    }

    final fullPhone = "${countryCode.value}${phone.value}";

    // Check existence on API
    final existsOnApi = await repo.checkUserExists(fullPhone);
    print("➡ register: exists on API? $existsOnApi");
    if (existsOnApi) {
      _snack('Account Exists', 'An account already exists for this number.');
      return;
    }

    loading.value = true;
    try {
      await repo.register(RegisterRequest(name: name.value, phone: fullPhone));
      _snack('Success', 'Registration OTP sent');
      Get.toNamed(Routes.otp);
    } catch (e) {
      print("❌ register error: $e");
      _snack('Error', 'Failed to send OTP');
    } finally {
      loading.value = false;
    }
  }




  Future<void> verifyOtp() async {
    if (!Validators.isOtp(otp.value)) {
      _snack('Invalid', 'Enter 6-digit OTP');
      return;
    }

    loading.value = true;
    final fullPhone = "${countryCode.value}${phone.value}";

    try {
      print("➡ verifyOtp: verifying OTP for $fullPhone");
      final ok = await repo.verifyOtp(OtpVerifyRequest(
        otp: otp.value,
        phone: fullPhone,
      ));
      print("🔎 verifyOtp result: $ok");

      if (ok) {
        try {
          // If user already exists, fetch id; else create and get id
          String? userId = await repo.getUserIdByPhone(fullPhone);
          userId ??= await repo.saveUserToApi(
            name: name.value.isEmpty ? 'User' : name.value,
            phone: fullPhone,
            email: email.value,
          );

          if (userId != null) {
            await repo.saveUserIdToSecure(userId);
          }
        } catch (apiError) {
          print("❌ API save/fetch error: $apiError");
        }

        try {
          await repo.savePhoneToSecure(fullPhone);
        } catch (secureError) {
          print("❌ Secure storage error: $secureError");
        }

        _snack('Welcome', 'Account created successfully');
        Get.offAllNamed(Routes.shell);
      } else {
        _snack('Error', 'Incorrect or expired OTP');
      }
    } catch (e) {
      print("❌ verifyOtp error: $e");
    } finally {
      loading.value = false;
    }
  }
}
