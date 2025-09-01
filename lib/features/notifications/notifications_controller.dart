import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final items = List.generate(8, (i) => 'Your video received new views').obs;
}
