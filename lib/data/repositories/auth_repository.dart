import 'package:dio/dio.dart';
import '../../config/env.dart';
import '../../core/services/api_client.dart';
import '../models/auth_models.dart';

abstract class IAuthRepository {
  Future<void> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
  Future<bool> verifyOtp(OtpVerifyRequest request);
  Future<AuthUser> me();
}

class AuthRepository implements IAuthRepository {
  AuthRepository(this.client);
  final ApiClient client;

  @override
  Future<void> login(LoginRequest request) async {
    if (Env.useMocks) { await Future<void>.delayed(const Duration(milliseconds: 400)); return; }
    await client.dio.post(Env.epLogin, data: request.toJson());
  }

  @override
  Future<void> register(RegisterRequest request) async {
    if (Env.useMocks) { await Future<void>.delayed(const Duration(milliseconds: 400)); return; }
    await client.dio.post(Env.epRegister, data: request.toJson());
  }

  @override
  Future<bool> verifyOtp(OtpVerifyRequest request) async {
    if (Env.useMocks) { await Future<void>.delayed(const Duration(milliseconds: 300)); return request.otp == '123456'; }
    final res = await client.dio.post(Env.epVerifyOtp, data: request.toJson());
    return res.data['ok'] == true;
  }

  @override
  Future<AuthUser> me() async {
    if (Env.useMocks) return AuthUser.mock();
    final res = await client.dio.get('/me');
    return AuthUser(id: res.data['id'], name: res.data['name'], phone: res.data['phone']);
  }
}
