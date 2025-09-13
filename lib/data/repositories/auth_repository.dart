import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../../core/services/api_client.dart';
import '../../core/services/secure_store.dart';
import '../../core/services/whatsapp_service.dart';
import '../models/auth_models.dart';

abstract class IAuthRepository {
  Future<void> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
  Future<bool> verifyOtp(OtpVerifyRequest request);
  Future<AuthUser> me();

  /// Save to backend and return userId if successful
  Future<String?> saveUserToApi({
    required String name,
    required String phone,
    required String email,
  });

  Future<void> savePhoneToSecure(String phone);
  Future<String?> getPhoneFromSecure();

  Future<void> saveUserIdToSecure(String id);
  Future<String?> getUserIdFromSecure();

  Future<bool> checkUserExists(String phone);

  /// Fetch user details by phone and return id if exists
  Future<String?> getUserIdByPhone(String phone);
}

class AuthRepository implements IAuthRepository {
  AuthRepository(this.client, this.secure, this.wa);
  final ApiClient client;
  final SecureStore secure;
  final WhatsAppService wa;

  @override
  Future<bool> checkUserExists(String phone) async {
    try {
      print("📞 Checking user existence for phone: $phone");

      final queryParams = {
        "method": "GET",
        "table": "users",
        "where": "phone=${phone.replaceAll("'", "")}",
      };
      print("➡ Sending API request with params: $queryParams");


      print("➡ Sending API request with params: $queryParams");

      final res = await client.dio.get(
        "https://fake-api.devsecit.com/api/v1",
        queryParameters: queryParams,
      );

      print("🟢 API raw response for $phone => ${res.data}");

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      if (data is Map<String, dynamic>) {
        // Look for nested "data" field
        if (data.containsKey("data")) {
          final inner = data["data"];
          print("🔎 Checking inner data: $inner");

          if (inner is List && inner.isNotEmpty) return true;
          if (inner is Map && inner.isNotEmpty) return true;
          return false;
        }
        print("🔎 Checking top-level map data: $data");
        return data.isNotEmpty;
      }

      if (data is List) {
        print("🔎 Checking list response: $data");
        return data.isNotEmpty;
      }

      print("❌ Unexpected API response type: ${data.runtimeType}");
      return false;
    } catch (e) {
      print("❌ checkUserExists error: $e");
      return false;
    }
  }

  @override
  Future<String?> getUserIdByPhone(String phone) async {
    try {
      final queryParams = {
        "method": "GET",
        "table": "users",
        "where": "phone='${phone.replaceAll("'", "")}'",
      };

      final res = await client.dio.get(
        "https://fake-api.devsecit.com/api/v1",
        queryParameters: queryParams,
      );

      final data = res.data is String ? jsonDecode(res.data) : res.data;
      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map && first['id'] != null) {
          return first['id'].toString();
        }
      }
      if (data is Map<String, dynamic> && data['id'] != null) {
        return data['id'].toString();
      }
      return null;
    } catch (e) {
      print("❌ getUserIdByPhone error: $e");
      return null;
    }
  }

  @override
  Future<void> login(LoginRequest request) async {
    print("➡ login called with: ${request.toJson()}");

    if (!Env.useWhatsAppOtp) {
      await client.dio.post(Env.epLogin, data: request.toJson());
      return;
    }

    final otp = _generateOtp(Env.otpLength);
    final ok = await wa.sendOtp(phone: request.phone, otp: otp);
    if (!ok) throw Exception('Failed to send OTP');

    await secure.saveOtp(
      phone: request.phone,
      otp: otp,
      expiresAt: DateTime.now().add(Env.otpTtl),
    );
  }

  @override
  Future<void> register(RegisterRequest request) async {
    print("➡ register called with: ${request.toJson()}");

    if (!Env.useWhatsAppOtp) {
      await client.dio.post(Env.epRegister, data: request.toJson());
      return;
    }

    final otp = _generateOtp(Env.otpLength);
    final ok = await wa.sendOtp(phone: request.phone, otp: otp);
    if (!ok) throw Exception('Failed to send OTP');

    await secure.saveOtp(
      phone: request.phone,
      otp: otp,
      expiresAt: DateTime.now().add(Env.otpTtl),
    );
  }

  @override
  Future<bool> verifyOtp(OtpVerifyRequest request) async {
    print("➡ verifyOtp called with: ${request.toJson()}");

    if (!Env.useWhatsAppOtp) {
      final res = await client.dio.post(Env.epVerifyOtp, data: request.toJson());
      return res.data['ok'] == true;
    }

    final data = await secure.readOtp();
    if (data == null) return false;

    final savedPhone = (data['phone'] ?? '') as String;
    final savedOtp = (data['otp'] ?? '') as String;
    final expiresAt = DateTime.tryParse((data['expiresAt'] ?? '') as String);

    final now = DateTime.now();
    final valid = savedPhone == request.phone &&
        savedOtp == request.otp &&
        (expiresAt != null && now.isBefore(expiresAt));

    print("🔎 OTP validation check: savedPhone=$savedPhone, inputPhone=${request.phone}, savedOtp=$savedOtp, inputOtp=${request.otp}, valid=$valid");

    if (valid) {
      await secure.clearOtp();
      return true;
    }
    return false;
  }

  @override
  Future<AuthUser> me() async {
    if (Env.useWhatsAppOtp) return AuthUser.mock();
    final res = await client.dio.get('/me');
    return AuthUser(
      id: res.data['id'],
      name: res.data['name'],
      phone: res.data['phone'],
    );
  }

  @override
  Future<String?> saveUserToApi({
    required String name,
    required String phone,
    required String email,
  }) async {
    final queryParams = {
      "method": "PUT",
      "table": "users",
      "name": name,
      "phone": phone,
      "email": email,
    };

    print("➡ saveUserToApi called with: $queryParams");

    try {
      final res = await client.dio.post(
        "https://fake-api.devsecit.com/api/v1",
        queryParameters: queryParams,
      );

      print("🟢 saveUserToApi response: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;
        if (data["err"] == true) {
          throw Exception(data["msg"] ?? "Failed to save user");
        }
        return data["id"]?.toString();
      }
      return null;
    } catch (e) {
      print("❌ Error in saveUserToApi: $e");
      return null;
    }
  }

  @override
  Future<void> savePhoneToSecure(String phone) async {
    await secure.savePhone(phone);
  }

  @override
  Future<String?> getPhoneFromSecure() async {
    return secure.getPhone();
  }

  @override
  Future<void> saveUserIdToSecure(String id) async {
    await secure.saveUserId(id);
  }

  @override
  Future<String?> getUserIdFromSecure() async {
    return secure.getUserId();
  }

  String _generateOtp(int len) {
    final rnd = Random.secure();
    final buf = StringBuffer();
    for (int i = 0; i < len; i++) {
      buf.write(rnd.nextInt(10));
    }
    return buf.toString();
  }
}
