import 'package:dio/dio.dart';
import '../../config/env.dart';

class ApiClient {
  ApiClient() {
    final base = BaseOptions(baseUrl: Env.baseUrl, connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15), contentType: 'application/json');
    dio = Dio(base);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // TODO: attach token from secure store
        return handler.next(options);
      },
      onError: (err, handler) => handler.next(err),
    ));
  }

  late final Dio dio;
}
