import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'kyc_controller.dart';

class KycView extends GetView<KycController> {
  const KycView({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data found.'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(resp.spacing(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile avatar
              Center(
                child: CircleAvatar(
                  radius: resp.isTablet ? 60 : 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: resp.isTablet ? 60 : 50, color: Colors.white),
                ),
              ),
              SizedBox(height: resp.spacing(16)),

              // Name
              Text('Name', style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: resp.spacing(4)),
              TextFormField(
                initialValue: profile.name,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: resp.spacing(12)),

              // Email
              Text('Email', style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: resp.spacing(4)),
              TextFormField(
                initialValue: profile.email,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: resp.spacing(12)),

              // Phone
              Text('Phone', style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: resp.spacing(4)),
              TextFormField(
                initialValue: profile.phone,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: resp.spacing(12)),

              // Address
              Text('Address', style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: resp.spacing(4)),
              TextFormField(
                initialValue: profile.address,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: resp.spacing(16)),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}