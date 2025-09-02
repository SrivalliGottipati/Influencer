class LoginRequest {
  LoginRequest({required this.phone});
  final String phone;
  Map<String, dynamic> toJson() => {'phone': phone};
}

class RegisterRequest {
  RegisterRequest({required this.name, required this.phone});
  final String name;
  final String phone;
  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};
}

class OtpVerifyRequest {
  OtpVerifyRequest({required this.otp, required this.phone});
  final String otp;
  final String phone;
  Map<String, dynamic> toJson() => {'otp': otp, 'phone': phone};
}

class AuthUser {
  AuthUser({required this.id, required this.name, required this.phone});
  final String id;
  final String name;
  final String phone;
  factory AuthUser.mock() => AuthUser(id: 'u1', name: 'Alex', phone: '9999999999');
}
