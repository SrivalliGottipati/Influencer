import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'referrals_controller.dart';

class ReferralsView extends GetView<ReferralsController> {
  const ReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(context.responsive.spacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Invite friends and earn ₹50 per successful referral.'),
            SizedBox(height: context.responsive.spacing(8)),

            // ✅ FIXED: removed Obx because `controller.link` is not reactive
            SelectableText(controller.link),

            SizedBox(height: context.responsive.spacing(12)),
            ElevatedButton.icon(
              onPressed: controller.share,
              icon: const Icon(Icons.share),
              label: const Text('Share Invite'),
            ),

            SizedBox(height: context.responsive.spacing(16)),
            const Text('Referral history'),
            SizedBox(height: context.responsive.spacing(8)),

            // ✅ Keep Obx only here, because `items` is observable
            Expanded(
              child: Obx(
                    () => ListView.separated(
                  itemBuilder: (_, i) {
                    final r = controller.items[i];
                    return ListTile(
                      title: Text(r.name),
                      subtitle: Text(r.date),
                      trailing: const Text('+₹50'),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: controller.items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
