import 'package:get/get.dart';
import '../../data/repositories/video_repository.dart';
import 'upload_controller.dart';

class UploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadController>(() => UploadController(Get.find<IVideoRepository>()));
  }
}
