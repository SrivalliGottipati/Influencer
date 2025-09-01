import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import 'upload_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(context.responsive.spacing(16)),
        child: Obx(() => Column(children: [
          AppInput(controller: c, label: 'Paste video URL'),
          SizedBox(height: context.responsive.spacing(12)),
          AppButton(label: 'Submit', loading: controller.loading.value, onPressed: () {
            controller.url.value = c.text.trim();
            controller.submit();
            c.clear();
          }),
        ])),
      ),
    );
  }
}
