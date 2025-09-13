import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  final _storage = const FlutterSecureStorage();

  // ---------------- OTP helpers ----------------
  Future<void> saveOtp({
    required String phone,
    required String otp,
    required DateTime expiresAt,
  }) async {
    final data = {
      'phone': phone,
      'otp': otp,
      'expiresAt': expiresAt.toIso8601String(),
    };
    await _storage.write(key: 'otp_data', value: jsonEncode(data)); // ✅ only once
  }


  Future<Map<String, dynamic>?> readOtp() async {
    final raw = await _storage.read(key: 'otp_data');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      // If it's a String (bad case), decode again
      if (decoded is String) {
        final second = jsonDecode(decoded);
        if (second is Map<String, dynamic>) {
          return second;
        }
      }
      // Handle case where decoded might be a List or other type
      if (decoded is List) {
        print("⚠️ readOtp: Unexpected list response: $decoded");
        return null;
      }
      print("⚠️ readOtp: Unexpected response type: ${decoded.runtimeType}, data: $decoded");
      return null;
    } catch (e) {
      print("⚠️ readOtp decode error: $e");
      return null;
    }
  }


  Future<void> clearOtp() => _storage.delete(key: 'otp_data');

  // ---------------- Generic helpers ----------------
  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // ---------------- Convenience for phone ----------------
  static const _phoneKey = 'user_phone';

  Future<void> savePhone(String phone) async {
    await setString(_phoneKey, phone);
  }

  Future<String?> getPhone() async {
    return getString(_phoneKey);
  }

  Future<void> clearPhone() async {
    await delete(_phoneKey);
  }

  static const _userIdKey = 'user_id';

  Future<void> saveUserId(String id) async {
    await setString(_userIdKey, id);
  }

  Future<String?> getUserId() async {
    return getString(_userIdKey);
  }

  Future<void> clearUserId() async {
    await delete(_userIdKey);
  }
}
