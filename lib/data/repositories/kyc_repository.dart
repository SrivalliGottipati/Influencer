import '../models/kyc_models.dart';

class KycRepository {
  // Mock API: Fetch profile
  Future<Profile> getProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    return Profile(
      name: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      phone: '+91 99999 99999',
      address: '123 Flutter Street, Mumbai, India',
    );
  }

  // Mock API: Update profile
  Future<Profile> updateProfile(Profile profile) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    return profile; // return updated profile
  }
}
