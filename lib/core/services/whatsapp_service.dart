import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../config/env.dart';

class WhatsAppService {
  WhatsAppService(this._dio);
  final Dio _dio;

  Future<bool> sendOtp({required String phone, required String otp}) async {
    final msg = 'Your OTP is $otp';
    final params = {
      'api_key': Env.waApiKey,
      'sender':  Env.waSender,
      'number':  phone,
      'message': msg,
      'full':    '1',
    };

    try {
      final res = await _dio.get(Env.waBaseUrl, queryParameters: params);
      debugPrint('📩 WhatsApp API Response: ${res.data}');
      return (res.data is Map) && (res.data['status'] == true);
    } catch (e) {
      debugPrint('❌ WhatsApp API Error: $e');
      return false;
    }
  }
}
