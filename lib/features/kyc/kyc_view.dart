import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/data/models/kyc_models.dart';
import 'kyc_controller.dart';

class KycView extends GetView<KycController> {
  const KycView({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;

    return Scaffold(
      body: Obx(() {
        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data found.'));
        }

        final nameCtrl = TextEditingController(text: profile.name);
        final emailCtrl = TextEditingController(text: profile.email);
        final phoneCtrl = TextEditingController(text: profile.phone);
        final addressCtrl = TextEditingController(text: profile.address);

        return SingleChildScrollView(
          padding: EdgeInsets.all(resp.spacing(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: resp.isTablet ? 60 : 50,
                      backgroundColor: AppColors.primary,
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : null,
                      child: controller.profileImage.value == null
                          ? Icon(Icons.person,
                          size: resp.isTablet ? 60 : 50,
                          color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          offset: const Offset(0, -100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                          onSelected: (value) {
                            if (value == 'camera') {
                              controller.takePhoto();
                            } else if (value == 'gallery') {
                              controller.pickImage();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'camera',
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt),
                                  SizedBox(width: 8),
                                  Text('Take Photo'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'gallery',
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library),
                                  SizedBox(width: 8),
                                  Text('Choose from Gallery'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: resp.spacing(16)),

              // Name
              Text('Name', style: Theme.of(context).textTheme.labelLarge),
              TextFormField(controller: nameCtrl,
                  decoration: const InputDecoration(border: OutlineInputBorder())),
              SizedBox(height: resp.spacing(12)),

              // Email
              Text('Email', style: Theme.of(context).textTheme.labelLarge),
              TextFormField(controller: emailCtrl,
                  decoration: const InputDecoration(border: OutlineInputBorder())),
              SizedBox(height: resp.spacing(12)),

              // Phone
              Text('Phone', style: Theme.of(context).textTheme.labelLarge),
              TextFormField(controller: phoneCtrl,
                  decoration: const InputDecoration(border: OutlineInputBorder())),
              SizedBox(height: resp.spacing(12)),

              // Address
              Text('Address', style: Theme.of(context).textTheme.labelLarge),
              TextFormField(
                controller: addressCtrl,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: resp.spacing(16)),

              // 🔹 KYC Document Upload
              Text('KYC Documents',
                  style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: resp.spacing(8)),
              Obx(() => Wrap(
                spacing: 8,
                children: [
                  ...controller.kycDocuments.map((doc) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(doc,
                        width: 80, height: 80, fit: BoxFit.cover),
                  )),
                  GestureDetector(
                    onTap: controller.pickKycDocument,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: AppColors.primary),
                    ),
                  ),
                ],
              )),
              SizedBox(height: resp.spacing(20)),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedProfile = Profile(
                      name: nameCtrl.text,
                      email: emailCtrl.text,
                      phone: phoneCtrl.text,
                      address: addressCtrl.text,
                    );
                    controller.updateProfile(updatedProfile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:
                    EdgeInsets.symmetric(vertical: resp.spacing(12)),
                  ),
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
