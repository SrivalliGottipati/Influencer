import 'package:get/get.dart';
import 'package:influencer/main.dart';
import '../app_shell.dart';
import '../config/app_routes.dart';

// Auth
import '../features/auth/auth_binding.dart';
import '../features/auth/login_view.dart';
import '../features/auth/register_view.dart';
import '../features/auth/otp_view.dart';

// Dashboard
import '../features/dashboard/dashboard_binding.dart';
import '../features/dashboard/dashboard_view.dart';

// KYC
import '../features/kyc/kyc_binding.dart';
import '../features/kyc/kyc_view.dart';

// Upload
import '../features/notifications/notification_view.dart';
import '../features/upload/upload_binding.dart';
import '../features/upload/upload_view.dart';

// Referrals
import '../features/referrals/referrals_binding.dart';
import '../features/referrals/referrals_view.dart';

// Wallet
import '../features/wallet/wallet_binding.dart';
import '../features/wallet/wallet_view.dart';

// Notifications
import '../features/notifications/notifications_binding.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.login, page: () => LoginView(), binding: AuthBinding()),
    GetPage(name: Routes.register, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(name: Routes.otp, page: () => const OtpView(), binding: AuthBinding()),

    GetPage(name: Routes.dashboard, page: () => const DashboardView(), binding: DashboardBinding()),
    GetPage(name: Routes.kyc, page: () => const KycView(), binding: KycBinding()),
    GetPage(name: Routes.upload, page: () => const UploadView(), binding: UploadBinding()),
    GetPage(name: Routes.referrals, page: () => const ReferralsView(), binding: ReferralsBinding()),
    GetPage(name: Routes.wallet, page: () => const WalletView(), binding: WalletBinding()),
    GetPage(name: Routes.notifications, page: () => const NotificationsView(), binding: NotificationsBinding()),
    GetPage(
      name: Routes.shell,
      page: () => const AppShell(),
      bindings: [
        DashboardBinding(),
        UploadBinding(),
        ReferralsBinding(),
        WalletBinding(),
        NotificationsBinding(),
        KycBinding()
      ],
    ),

  ];
}
