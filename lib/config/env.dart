class Env {
  // Set to false when you have a backend
  static const bool useMocks = true;

  // Set baseUrl when useMocks = false
  static const String baseUrl = 'https://api.yourdomain.com';

  // Endpoints (placeholders)
  static const String epLogin = '/auth/login';
  static const String epRegister = '/auth/register';
  static const String epSendOtp = '/auth/send-otp';
  static const String epVerifyOtp = '/auth/verify-otp';
  static const String epKyc = '/kyc/submit';
  static const String epUploadVideo = '/videos';
  static const String epDashboard = '/dashboard/summary';
  static const String epReferrals = '/referrals';
  static const String epWallet = '/wallet';
}
