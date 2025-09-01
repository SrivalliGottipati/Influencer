// import 'package:get/get.dart';
// import 'package:get/get_instance/src/bindings_interface.dart';
// import 'package:influencer/data/repositories/kyc_repository.dart';
// import 'package:influencer/features/kyc/kyc_controller.dart';
//
// class KycBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<KycController>(
//           () => KycController(Get.find<IKycRepository>()),
//       fenix: true,
//     );
//   }
// }

import 'package:get/get.dart';
import 'kyc_controller.dart';

class KycBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycController>(() => KycController());
  }
}
