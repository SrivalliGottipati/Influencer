import 'package:dio/dio.dart';
import '../../config/env.dart';

class ApiClient {
  ApiClient({String? baseUrl}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    if (Env.useMocks) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // 🚫 Don’t mock OTP calls
          if (options.path.contains(Env.waBaseUrl)) {
            return handler.next(options);
          }

          // ✅ Mock everything else
          switch (options.path) {
            case Env.epLogin:
              return handler.resolve(Response(
                requestOptions: options,
                data: {"status": true, "token": "mock-token"},
              ));
            case Env.epDashboard:
              return handler.resolve(Response(
                requestOptions: options,
                data: {"status": true, "summary": {"balance": 5000}},
              ));
          // add more mocks as needed
          }
          return handler.next(options);
        },
      ));
    }
  }

  late final Dio dio;
}
