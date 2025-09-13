// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
//
// import 'package:influencer/data/models/kyc_models.dart';
// import 'package:influencer/data/repositories/kyc_repository.dart';
// import '../../core/services/notification_service.dart';
//
// class KycController extends GetxController {
//   final KycRepository repository = KycRepository();
//   final ImagePicker _picker = ImagePicker();
//
//   var profile = Rx<Profile?>(null);
//   var isLoading = false.obs;
//
//   // Profile photo
//   var profileImage = Rx<File?>(null);
//
//   // KYC documents
//   var kycDocuments = <File>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//     _loadLocalData();
//   }
//
//   /// 🔹 Load locally saved profile photo & documents
//   Future<void> _loadLocalData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//
//       final profilePath = prefs.getString('profileImage');
//       if (profilePath != null && File(profilePath).existsSync()) {
//         profileImage.value = File(profilePath);
//       }
//
//       final docs = prefs.getStringList('kycDocuments') ?? [];
//       kycDocuments.assignAll(
//         docs.map((p) => File(p)).where((f) => f.existsSync()),
//       );
//     } catch (e) {
//       print("⚠️ SharedPreferences error: $e");
//     }
//   }
//
//   /// 🔹 Save profile image path locally
//   Future<void> _saveProfileImage(String path) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('profileImage', path);
//     } catch (e) {
//       print("⚠️ Failed to save profile image: $e");
//     }
//   }
//
//   /// 🔹 Save KYC docs paths locally
//   Future<void> _saveKycDocuments() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setStringList(
//         'kycDocuments',
//         kycDocuments.map((f) => f.path).toList(),
//       );
//     } catch (e) {
//       print("⚠️ Failed to save KYC docs: $e");
//     }
//   }
//
//   /// 🔹 Persist file in app directory (with unique name)
//   Future<File> _persistFile(XFile file) async {
//     final appDir = await getApplicationDocumentsDirectory();
//     final ext = p.extension(file.path);
//     final newPath =
//         '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}$ext';
//     final savedFile = await File(file.path).copy(newPath);
//     return savedFile;
//   }
//
//   Future<void> fetchProfile() async {
//     try {
//       isLoading.value = true;
//       profile.value = await repository.getProfile();
//     } catch (_) {
//       NotificationService.showError('Error', 'Failed to load profile');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 512,
//         maxHeight: 512,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         final savedFile = await _persistFile(image);
//         profileImage.value = savedFile;
//         await _saveProfileImage(savedFile.path);
//         NotificationService.showInfo('Image Selected', 'Profile image updated');
//       }
//     } catch (e) {
//       NotificationService.showError('Error', 'Failed to pick image');
//       print("⚠️ Image picker error: $e");
//     }
//   }
//
//   Future<void> takePhoto() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 512,
//         maxHeight: 512,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         final savedFile = await _persistFile(image);
//         profileImage.value = savedFile;
//         await _saveProfileImage(savedFile.path);
//         NotificationService.showInfo('Photo Taken', 'Profile photo captured');
//       }
//     } catch (e) {
//       NotificationService.showError('Error', 'Failed to take photo');
//       print("⚠️ Camera error: $e");
//     }
//   }
//
//   Future<void> pickKycDocument() async {
//     try {
//       final XFile? file = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
//       if (file != null) {
//         final savedFile = await _persistFile(file);
//         kycDocuments.add(savedFile);
//         await _saveKycDocuments();
//         NotificationService.showInfo(
//             'Document Added', 'KYC document uploaded');
//       }
//     } catch (e) {
//       NotificationService.showError('Error', 'Failed to upload document');
//       print("⚠️ KYC doc picker error: $e");
//     }
//   }
//
//   /// Update without full reload
//   Future<void> updateProfile(Profile updatedProfile) async {
//     try {
//       // Update locally first
//       profile.value = updatedProfile;
//
//       // Send to server in background
//       final result = await repository.updateProfile(updatedProfile);
//       profile.value = result;
//
//       NotificationService.showProfileUpdated();
//     } catch (_) {
//       NotificationService.showError('Error', 'Failed to update profile');
//     }
//   }
// }


import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:influencer/data/models/kyc_models.dart';
import 'package:influencer/data/repositories/kyc_repository.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/secure_store.dart';

class KycController extends GetxController {
  final KycRepository repository = KycRepository();
  final ImagePicker _picker = ImagePicker();
  final SecureStore secure = SecureStore();

  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;

  var profileImage = Rx<File?>(null);
  var kycDocuments = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalData();
    fetchProfileFromApi();
  }

  Future<void> _loadLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final profilePath = prefs.getString('profileImage');
      if (profilePath != null && File(profilePath).existsSync()) {
        profileImage.value = File(profilePath);
        print("➡ Loaded profile image from local: $profilePath");
      }

      final docs = prefs.getStringList('kycDocuments') ?? [];
      kycDocuments.assignAll(
        docs.map((p) => File(p)).where((f) => f.existsSync()),
      );
      print("➡ Loaded ${kycDocuments.length} KYC documents from local");
    } catch (e) {
      print("⚠️ SharedPreferences error: $e");
    }
  }

  Future<void> _saveProfileImage(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', path);
      print("➡ Saved profile image path locally: $path");
    } catch (e) {
      print("⚠️ Failed to save profile image: $e");
    }
  }

  Future<void> _saveKycDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'kycDocuments',
        kycDocuments.map((f) => f.path).toList(),
      );
      print("➡ Saved ${kycDocuments.length} KYC documents locally");
    } catch (e) {
      print("⚠️ Failed to save KYC docs: $e");
    }
  }

  Future<File> _persistFile(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(file.path);
    final newPath =
        '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}$ext';
    final savedFile = await File(file.path).copy(newPath);
    print("➡ Persisted file: $newPath");
    return savedFile;
  }

  Future<void> fetchProfileFromApi() async {
    try {
      final userId = await secure.getUserId();
      final phone = await secure.getPhone();
      isLoading.value = true;
      if (userId != null && userId.isNotEmpty) {
        print("➡ Fetching profile for userId=$userId from API...");
        profile.value = await repository.getProfile(userId);
      } else if (phone != null && phone.isNotEmpty) {
        print("➡ Fetching profile by phone=$phone from API...");
        profile.value = await repository.getProfileByPhone(phone);
      } else {
        print("❌ No userId/phone found in secure storage.");
      }
      print("🟢 Fetched profile: ${profile.value?.toJson()}");
    } catch (e) {
      print("❌ Failed to fetch profile: $e");
      NotificationService.showError('Error', 'Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        final savedFile = await _persistFile(image);
        profileImage.value = savedFile;
        await _saveProfileImage(savedFile.path);
        NotificationService.showInfo('Image Selected', 'Profile image updated');
      }
    } catch (e) {
      print("⚠️ Image picker error: $e");
      NotificationService.showError('Error', 'Failed to pick image');
    }

  }

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        final savedFile = await _persistFile(image);
        profileImage.value = savedFile;
        await _saveProfileImage(savedFile.path);
        NotificationService.showInfo('Photo Taken', 'Profile photo captured');
      }
    } catch (e) {
      print("⚠️ Camera error: $e");
      NotificationService.showError('Error', 'Failed to take photo');
    }
  }

  Future<void> pickKycDocument() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) {
        final savedFile = await _persistFile(file);
        kycDocuments.add(savedFile);
        await _saveKycDocuments();
        NotificationService.showInfo(
            'Document Added', 'KYC document uploaded');
      }
    } catch (e) {
      print("⚠️ KYC doc picker error: $e");
      NotificationService.showError('Error', 'Failed to upload document');
    }
  }

  Future<void> updateProfileApi(Profile updatedProfile) async {
    try {
      // Sanitize N/A placeholders before sending
      String clean(String v) => (v.trim().toUpperCase() == 'N/A') ? '' : v;
      final sanitized = updatedProfile.copyWith(
        name: clean(updatedProfile.name),
        email: clean(updatedProfile.email),
        phone: clean(updatedProfile.phone),
        address: clean(updatedProfile.address),
        city: clean(updatedProfile.city),
        state: clean(updatedProfile.state),
        zipCode: clean(updatedProfile.zipCode),
        country: clean(updatedProfile.country),
        gender: clean(updatedProfile.gender),
        dateOfBirth: clean(updatedProfile.dateOfBirth),
        nationality: clean(updatedProfile.nationality),
        role: clean(updatedProfile.role),
      );

      profile.value = sanitized;
      print("➡ Preparing update for: ${sanitized.toJson()}");

      // Pre-update: load current to avoid unnecessary UPDATE calls
      Profile? current;
      try {
        current = await repository.getProfileByPhone(sanitized.phone);
      } catch (_) {}

      final changed = current == null ||
          current.name != sanitized.name ||
          current.phone != sanitized.phone ||
          current.email != sanitized.email ||
          current.address != sanitized.address ||
          current.gender != sanitized.gender ||
          current.dateOfBirth != sanitized.dateOfBirth ||
          current.city != sanitized.city ||
          current.state != sanitized.state ||
          current.country != sanitized.country ||
          current.zipCode != sanitized.zipCode ||
          current.nationality != sanitized.nationality ||
          current.role != sanitized.role;

      if (!changed) {
        print("ℹ️ No changes detected. Skipping update.");
        NotificationService.showInfo('No Changes', 'Nothing to update');
        return;
      }

      print("➡ Updating profile via API (name/phone/email only)");
      final result = await repository.updateProfile(sanitized);

      // After update, fetch the latest row by phone to avoid duplicates and sync latest id
      try {
        final fresh = await repository.getProfileByPhone(sanitized.phone);
        profile.value = fresh;
        await secure.saveUserId(fresh.id);
        print("🟢 Profile refreshed post-update, latest id=${fresh.id}");
      } catch (e) {
        // If refresh fails, keep result
        profile.value = result;
        print("⚠️ Post-update refresh failed: $e");
      }

      NotificationService.showProfileUpdated();
    } catch (e) {
      print("❌ Failed to update profile: $e");
      NotificationService.showError('Error', 'Failed to update profile');
    }
  }
}



