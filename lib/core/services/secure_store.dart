import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  final _storage = const FlutterSecureStorage();

  Future<void> saveOtp({
    required String phone,
    required String otp,
    required DateTime expiresAt,
  }) async {
    final data = jsonEncode({
      'phone': phone,
      'otp': otp,
      'expiresAt': expiresAt.toIso8601String(),
    });
    await _storage.write(key: 'otp_data', value: data);
  }

  Future<Map<String, dynamic>?> readOtp() async {
    final raw = await _storage.read(key: 'otp_data');
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearOtp() => _storage.delete(key: 'otp_data');
}
