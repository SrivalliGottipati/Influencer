import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.separated(padding: EdgeInsets.all(context.responsive.spacing(16)), itemCount: controller.items.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (_, i) {
        return ListTile(title: Text('Notification #${i + 1}'), subtitle: Text(controller.items[i]), trailing: const Text('2h'));
      })),
    );
  }
}
