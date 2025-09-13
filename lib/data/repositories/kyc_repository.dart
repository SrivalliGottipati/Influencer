// import '../models/kyc_models.dart';
//
// class KycRepository {
//   // Mock API: Fetch profile
//   Future<Profile> getProfile() async {
//     await Future.delayed(const Duration(seconds: 1)); // simulate network
//     return Profile(
//       name: 'Alex Johnson',
//       email: 'alex.johnson@example.com',
//       phone: '+91 99999 99999',
//       address: '123 Flutter Street, Mumbai, India',
//     );
//   }
//
//   // Mock API: Update profile
//   Future<Profile> updateProfile(Profile profile) async {
//     await Future.delayed(const Duration(seconds: 1)); // simulate network
//     return profile; // return updated profile
//   }
// }


import '../models/kyc_models.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class KycRepository {
  final Dio dio = Dio();

  // GET profile by userId
  Future<Profile> getProfile(String userId) async {
    print("➡ Fetching profile for userId=$userId");
    final res = await dio.get(
      "https://fake-api.devsecit.com/api/v1",
      queryParameters: {
        "method": "GET",
        "table": "users",
        "where": "id='$userId'",
      },
    );
    print("🟢 GET API response: ${res.data}");

    final data = res.data is String ? _tryDecode(res.data) : res.data;
    if (data is List && data.isNotEmpty) {
      // API appears to append audit rows per update; pick the latest entry
      final last = data.last;
      if (last is Map<String, dynamic>) return Profile.fromJson(last);
      if (last is Map) return Profile.fromJson(Map<String, dynamic>.from(last));
    }
    if (data is Map<String, dynamic>) {
      // Some APIs may return a single object
      return Profile.fromJson(data);
    }
    throw Exception("User not found");
  }

  // GET profile by phone
  Future<Profile> getProfileByPhone(String phone) async {
    print("➡ Fetching profile for phone=$phone");
    final res = await dio.get(
      "https://fake-api.devsecit.com/api/v1",
      queryParameters: {
        "method": "GET",
        "table": "users",
        "where": "phone='${phone.replaceAll("'", "")}'",
      },
    );
    print("🟢 GET API response (phone): ${res.data}");

    final data = res.data is String ? _tryDecode(res.data) : res.data;
    if (data is List && data.isNotEmpty) {
      // Multiple rows for same user; take the latest
      final last = data.last;
      if (last is Map<String, dynamic>) return Profile.fromJson(last);
      if (last is Map) return Profile.fromJson(Map<String, dynamic>.from(last));
    }
    if (data is Map<String, dynamic>) {
      return Profile.fromJson(data);
    }
    throw Exception("User not found by phone");
  }

  dynamic _tryDecode(String raw) {
    try {
      return raw.isNotEmpty ? (raw.trim().startsWith('{') || raw.trim().startsWith('[')) ? (dio.transformer as DefaultTransformer).jsonDecodeCallback!(raw) : raw : raw;
    } catch (_) {
      try {
        return raw.isNotEmpty ? jsonDecode(raw) : raw;
      } catch (_) {
        return raw;
      }
    }
  }

  // UPDATE profile
  Future<Profile> updateProfile(Profile profile) async {
    // Send all details as query parameters per latest API guidance
    final query = {
      "method": "UPDATE",
      "table": "users",
      "name": profile.name,
      "phone": profile.phone,
      "email": profile.email,
      // additional fields if supported
      "address": profile.address,
      "gender": profile.gender,
      "date_of_birth": profile.dateOfBirth,
      "city": profile.city,
      "state": profile.state,
      "country": profile.country,
      "zip_code": profile.zipCode,
      "nationality": profile.nationality,
      "role": profile.role,
      "where": "id=${profile.id}",
    };
    print("➡ Sending UPDATE API with query: $query");

    final res = await dio.post(
      "https://fake-api.devsecit.com/api/v1",
      queryParameters: query,
    );

    print("🟢 UPDATE API response: ${res.data}");

    final data = res.data is String ? _tryDecode(res.data) : res.data;
    if (data is Map<String, dynamic>) {
      // API typically returns status object; on success just return the updated profile
      final err = data['err'];
      if (err == false || err == null) return profile;
      throw Exception(data['msg']?.toString() ?? 'Update failed');
    }
    // If API echoes the updated record as a list/map, try to parse
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map<String, dynamic>) return Profile.fromJson(first);
      if (first is Map) return Profile.fromJson(Map<String, dynamic>.from(first));
    }
    // Fallback to returning the same profile on ambiguous success
    return profile;
  }
}
