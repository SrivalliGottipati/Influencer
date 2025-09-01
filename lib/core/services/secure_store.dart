import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  final _s = const FlutterSecureStorage();
  Future<void> write(String key, String value) => _s.write(key: key, value: value);
  Future<String?> read(String key) => _s.read(key: key);
  Future<void> delete(String key) => _s.delete(key: key);
}
