class Validators {
  static bool isPhone(String v) => RegExp(r'^\d{10}$').hasMatch(v);
  static bool isOtp(String v) => RegExp(r'^\d{6}$').hasMatch(v);
  static bool isUrl(String v) => Uri.tryParse(v)?.hasAbsolutePath ?? false;
}
