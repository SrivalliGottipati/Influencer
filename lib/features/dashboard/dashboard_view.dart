import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/info_card.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(context.responsive.spacing(16)),
        child: Obx(() {
          final s = controller.summary.value;
          if (s == null) return const Center(child: CircularProgressIndicator());

          // Dummy performance data
          final performanceValues = [100, 200, 150, 300, 250, 400, 380];
          final maxValue = performanceValues.reduce((a, b) => a > b ? a : b);
          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

          return ListView(
            children: [
              Wrap(
                spacing: context.responsive.spacing(12),
                runSpacing: context.responsive.spacing(12),
                children: [
                  SizedBox(
                      width: context.responsive.isPhone ? double.infinity : 260,
                      child: InfoCard(
                          title: 'Videos',
                          value: '${s.total}',
                          icon: Icons.video_collection)),
                  SizedBox(
                      width: context.responsive.isPhone ? double.infinity : 260,
                      child: InfoCard(
                          title: 'Views',
                          value: '${s.views}',
                          icon: Icons.visibility)),
                  SizedBox(
                      width: context.responsive.isPhone ? double.infinity : 260,
                      child: InfoCard(
                          title: 'Profit (₹)',
                          value: s.earnings.toStringAsFixed(0),
                          icon: Icons.currency_rupee)),
                ],
              ),
              SizedBox(height: context.responsive.spacing(16)),

              // Performance title
              Text('Performance (7 days)', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: context.responsive.spacing(12)),

              // Custom animated bar chart
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final value = performanceValues[index];
                    final barHeight = (value / maxValue) * 150;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Value label
                        Text(
                          '$value',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),

                        // Animated bar
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500 + 100 * index),
                          width: 20,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Day label
                        Text(
                          days[index],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              SizedBox(height: context.responsive.spacing(16)),

              // Top videos section
              Text('Top videos', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: context.responsive.spacing(8)),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: const Icon(Icons.play_circle_fill),
                    title: Text('Video #${i + 1}'),
                    subtitle: Text('Views: ${(i + 1) * 5000}'),
                    trailing: Text('₹${(i + 1) * 150}'),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
