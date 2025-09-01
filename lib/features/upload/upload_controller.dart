import 'package:get/get.dart';
import 'package:influencer/data/repositories/video_repository.dart';
import 'package:influencer/data/models/video_models.dart';
import '../../core/utils/validators.dart';
import '../../core/services/notification_service.dart';

class UploadController extends GetxController {
  UploadController(this.repo);
  final IVideoRepository repo;
  final url = ''.obs;
  final loading = false.obs;

  Future<void> submit() async {
    if (!Validators.isUrl(url.value)) {
      NotificationService.showError('Invalid', 'Enter valid URL');
      return;
    }

    loading.value = true;
    try {
      await repo.add(VideoLinkRequest(url: url.value));
      NotificationService.showVideoUploaded();
    } catch (e) {
      NotificationService.showError('Error', 'Failed to upload video');
    } finally {
      loading.value = false;
    }
  }
}
