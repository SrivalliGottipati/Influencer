import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final items = <String>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // simulate API call
    items.assignAll(List.generate(8, (i) => 'Your video received new views'));
    isLoading.value = false;
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}
