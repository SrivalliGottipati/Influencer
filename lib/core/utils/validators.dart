class Validators {
  static bool isPhone(String v) => RegExp(r'^\d{10}$').hasMatch(v);
  static bool isOtp(String v) => RegExp(r'^\d{6}$').hasMatch(v);
  static bool isUrl(String v) => Uri.tryParse(v)?.hasAbsolutePath ?? false;
  static bool isEmail(String v) =>
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(v);
  static bool nonEmpty(String v) => v.trim().isNotEmpty;
}
