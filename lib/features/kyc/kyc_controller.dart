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
