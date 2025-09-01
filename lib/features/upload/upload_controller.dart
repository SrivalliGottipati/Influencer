import 'package:get/get.dart';
import 'package:influencer/data/repositories/video_repository.dart';
import 'package:influencer/data/models/video_models.dart';
import '../../core/utils/validators.dart';

class UploadController extends GetxController {
  UploadController(this.repo);
  final IVideoRepository repo;
  final url = ''.obs;
  final loading = false.obs;

  Future<void> submit() async {
    if (!Validators.isUrl(url.value)) {
      Get.snackbar('Invalid', 'Enter valid URL');
      return;
    }

    loading.value = true;
    await repo.add(VideoLinkRequest(url: url.value));
    loading.value = false;
    Get.snackbar('Success', 'Video link added');
  }
}
