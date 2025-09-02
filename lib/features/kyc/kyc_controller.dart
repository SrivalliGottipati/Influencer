import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:influencer/data/models/kyc_models.dart';
import 'package:influencer/data/repositories/kyc_repository.dart';
import '../../core/services/notification_service.dart';

class KycController extends GetxController {
  final KycRepository repository = KycRepository();
  final ImagePicker _picker = ImagePicker();

  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;

  // Profile photo
  var profileImage = Rx<File?>(null);

  // KYC documents
  var kycDocuments = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    _loadLocalData();
  }

  /// 🔹 Load locally saved profile photo & documents
  Future<void> _loadLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final profilePath = prefs.getString('profileImage');
      if (profilePath != null && File(profilePath).existsSync()) {
        profileImage.value = File(profilePath);
      }

      final docs = prefs.getStringList('kycDocuments') ?? [];
      kycDocuments.assignAll(
        docs.map((p) => File(p)).where((f) => f.existsSync()),
      );
    } catch (e) {
      print("⚠️ SharedPreferences error: $e");
    }
  }

  /// 🔹 Save profile image path locally
  Future<void> _saveProfileImage(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', path);
    } catch (e) {
      print("⚠️ Failed to save profile image: $e");
    }
  }

  /// 🔹 Save KYC docs paths locally
  Future<void> _saveKycDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'kycDocuments',
        kycDocuments.map((f) => f.path).toList(),
      );
    } catch (e) {
      print("⚠️ Failed to save KYC docs: $e");
    }
  }

  /// 🔹 Persist file in app directory (with unique name)
  Future<File> _persistFile(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(file.path);
    final newPath =
        '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}$ext';
    final savedFile = await File(file.path).copy(newPath);
    return savedFile;
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      profile.value = await repository.getProfile();
    } catch (_) {
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
      NotificationService.showError('Error', 'Failed to pick image');
      print("⚠️ Image picker error: $e");
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
      NotificationService.showError('Error', 'Failed to take photo');
      print("⚠️ Camera error: $e");
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
      NotificationService.showError('Error', 'Failed to upload document');
      print("⚠️ KYC doc picker error: $e");
    }
  }

  /// Update without full reload
  Future<void> updateProfile(Profile updatedProfile) async {
    try {
      // Update locally first
      profile.value = updatedProfile;

      // Send to server in background
      final result = await repository.updateProfile(updatedProfile);
      profile.value = result;

      NotificationService.showProfileUpdated();
    } catch (_) {
      NotificationService.showError('Error', 'Failed to update profile');
    }
  }
}
