// package:influencer/features/dashboard/dashboard_controller.dart
import 'package:get/get.dart';
import 'package:influencer/data/repositories/video_repository.dart';
import 'package:influencer/data/models/video_models.dart';

class DashboardController extends GetxController {
  DashboardController(this.videos);
  final IVideoRepository videos;

  final summary = Rxn<VideoSummary>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      final s = await videos.summary();
      summary.value = s;
    } catch (e) {
      Get.snackbar('Error', 'Failed loading dashboard');
    }
  }
}
