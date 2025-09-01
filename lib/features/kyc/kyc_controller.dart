import 'package:get/get.dart';
import 'package:influencer/data/models/kyc_models.dart';
import 'package:influencer/data/repositories/kyc_repository.dart';

class KycController extends GetxController {
  final KycRepository repository = KycRepository();

  // Observable profile info
  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      profile.value = await repository.getProfile();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Profile updatedProfile) async {
    try {
      isLoading.value = true;
      final result = await repository.updateProfile(updatedProfile);
      profile.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:influencer/data/models/kyc_models.dart';
// import 'package:influencer/data/repositories/kyc_repository.dart';
//
// class KycController extends GetxController {
//   final KycRepository repository = KycRepository();
//
//   var profile = Rx<Profile?>(null);
//   var isLoading = false.obs;
//   var selectedImage = Rx<File?>(null); // New observable for the picked image
//
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//   }
//
//   Future<void> fetchProfile() async {
//     try {
//       isLoading.value = true;
//       profile.value = await repository.getProfile();
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> updateProfile(Profile updatedProfile) async {
//     try {
//       isLoading.value = true;
//       final result = await repository.updateProfile(updatedProfile);
//       profile.value = result;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // New method: pick image from gallery
//   Future<void> pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       selectedImage.value = File(image.path);
//     }
//   }
// }
