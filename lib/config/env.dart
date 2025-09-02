class Env {
  /// Feature toggles
  static const bool useMocks = true; // ✅ mocks for everything except OTP
  static const bool useWhatsAppOtp = true; // ✅ always live for OTP

  /// WhatsApp API credentials
  static const String waBaseUrl = 'https://whatsapp.devsecit.com/send-message';
  static const String waApiKey  = 'rQnSOZ9zXWz65BQQyUtoKEs0lmQoc3';
  static const String waSender  = '919531654045';

  /// OTP config
  static const int otpLength = 6;
  static const Duration otpTtl = Duration(minutes: 5);

  /// API Endpoints (these will be mocked when useMocks = true)
  static const String epLogin     = '/auth/login';
  static const String epRegister  = '/auth/register';
  static const String epVerifyOtp = '/auth/verify-otp';
  static const String epKyc       = '/kyc/submit';
  static const String epUploadVideo = '/videos';
  static const String epDashboard = '/dashboard/summary';
  static const String epReferrals = '/referrals';
  static const String epWallet    = '/wallet';
}
