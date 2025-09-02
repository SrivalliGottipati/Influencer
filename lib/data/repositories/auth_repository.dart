import 'dart:math';
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
}

class AuthRepository implements IAuthRepository {
  AuthRepository(this.client, this.secure, this.wa);
  final ApiClient client;
  final SecureStore secure;
  final WhatsAppService wa;

  @override
  Future<void> login(LoginRequest request) async {
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
    if (!Env.useWhatsAppOtp) {
      await client.dio.post(Env.epRegister, data: request.toJson());
      return;
    }
    // For client-side demo, treat register same as login (send OTP)
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

  String _generateOtp(int len) {
    final rnd = Random.secure();
    final buf = StringBuffer();
    for (int i = 0; i < len; i++) {
      buf.write(rnd.nextInt(10));
    }
    return buf.toString();
  }
}
