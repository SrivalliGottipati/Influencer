// import 'package:get/get.dart';
// import '../../data/models/auth_models.dart';
// import '../../data/repositories/auth_repository.dart';
// import '../../core/utils/validators.dart';
// import '../../config/app_routes.dart';
//
// class AuthController extends GetxController {
//   AuthController(this.repo);
//   final IAuthRepository repo;
//
//   final phone = ''.obs;
//   final name  = ''.obs;
//   final otp   = ''.obs;
//   final loading = false.obs;
//
//   void _snack(String title, String msg) =>
//       Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);
//
//   Future<void> sendLoginOtp() async {
//     if (!Validators.isPhone(phone.value)) {
//       _snack('Invalid', 'Enter 10-digit phone');
//       return;
//     }
//     loading.value = true;
//     try {
//       await repo.login(LoginRequest(phone: phone.value));
//       _snack('OTP Sent', 'OTP sent to ${phone.value}');
//       Get.toNamed(Routes.otp);
//     } catch (e) {
//       _snack('Error', 'Failed to send OTP');
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   Future<void> register() async {
//     if (name.value.isEmpty || !Validators.isPhone(phone.value)) {
//       _snack('Invalid', 'Name & 10-digit phone required');
//       return;
//     }
//     loading.value = true;
//     try {
//       await repo.register(RegisterRequest(name: name.value, phone: phone.value));
//       _snack('Success', 'Registration OTP sent');
//       Get.toNamed(Routes.otp);
//     } catch (e) {
//       _snack('Error', 'Failed to send OTP');
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   Future<void> verifyOtp() async {
//     if (!Validators.isOtp(otp.value)) {
//       _snack('Invalid', 'Enter 6-digit OTP');
//       return;
//     }
//     loading.value = true;
//     try {
//       final ok = await repo.verifyOtp(OtpVerifyRequest(otp: otp.value, phone: phone.value));
//       if (ok) {
//         _snack('Welcome', 'Login successful');
//         Get.offAllNamed(Routes.shell); // or Routes.dashboard
//       } else {
//         _snack('Error', 'Incorrect or expired OTP');
//       }
//     } finally {
//       loading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/utils/validators.dart';
import '../../config/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this.repo);
  final IAuthRepository repo;

  final phone = ''.obs;
  final name  = ''.obs;
  final otp   = ''.obs;
  final loading = false.obs;

  // ✅ new: track selected country code (default India)
  final countryCode = '91'.obs;

  void _snack(String title, String msg) =>
      Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);

  Future<void> sendLoginOtp() async {
    if (!Validators.isPhone(phone.value)) {
      _snack('Invalid', 'Enter valid phone');
      return;
    }
    loading.value = true;
    try {
      final fullPhone = "${countryCode.value}${phone.value}";
      await repo.login(LoginRequest(phone: fullPhone));
      _snack('OTP Sent', 'OTP sent to $fullPhone');
      Get.toNamed(Routes.otp);
    } catch (e) {
      _snack('Error', 'Failed to send OTP');
    } finally {
      loading.value = false;
    }
  }

  Future<void> register() async {
    if (name.value.isEmpty || !Validators.isPhone(phone.value)) {
      _snack('Invalid', 'Name & valid phone required');
      return;
    }
    loading.value = true;
    try {
      final fullPhone = "${countryCode.value}${phone.value}";
      await repo.register(RegisterRequest(name: name.value, phone: fullPhone));
      _snack('Success', 'Registration OTP sent');
      Get.toNamed(Routes.otp);
    } catch (e) {
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
    try {
      final fullPhone = "${countryCode.value}${phone.value}";
      final ok = await repo.verifyOtp(OtpVerifyRequest(
        otp: otp.value,
        phone: fullPhone,
      ));
      if (ok) {
        _snack('Welcome', 'Login successful');
        Get.offAllNamed(Routes.shell); // or Routes.dashboard
      } else {
        _snack('Error', 'Incorrect or expired OTP');
      }
    } finally {
      loading.value = false;
    }
  }
}
