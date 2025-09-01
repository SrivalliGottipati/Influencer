// package:influencer/features/dashboard/dashboard_binding.dart

import 'package:get/get.dart';
import 'package:influencer/data/repositories/video_repository.dart';
import 'package:influencer/features/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient and VideoRepository are already bound in your app-level bindings:
    // Get.lazyPut<ApiClient>(() => ApiClient(...));
    // Get.lazyPut<IVideoRepository>(() => VideoRepository(Get.find<ApiClient>()));
    Get.lazyPut<DashboardController>(() => DashboardController(Get.find<IVideoRepository>()));
  }
}
