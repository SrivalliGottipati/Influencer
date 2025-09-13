import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/text_styles.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_card.dart';
import 'auth_controller.dart';
import '../../core/utils/validators.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final resp = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.ink),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(resp.spacing(24)),
          child: Column(
            children: [
              SizedBox(height: resp.spacing(20)),
              
              // Header Section
              _buildHeaderSection(resp),
              
              SizedBox(height: resp.spacing(40)),
              
              // Registration Form
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: AppCard(
                  child: Obx(() => Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Create Account",
                          style: AppTextStyles.headlineLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: resp.spacing(8)),
                        Text(
                          "Fill in your details to get started",
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.muted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: resp.spacing(32)),

                        // Full Name Input
                        AppInput(
                          controller: nameCtrl,
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icons.person_outline,
                          validator: (v) {
                            if (!Validators.nonEmpty((v ?? ''))) return 'Name is required';
                            return null;
                          },
                        ),
                        SizedBox(height: resp.spacing(20)),

                        // Email Input
                        AppInput(
                          controller: emailCtrl,
                          label: 'Email Address',
                          hintText: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (v) {
                            final t = (v ?? '').trim();
                            if (t.isEmpty) return 'Email is required';
                            if (!Validators.isEmail(t)) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        SizedBox(height: resp.spacing(20)),

                        // Phone Input
                        AppInput(
                          controller: phoneCtrl,
                          label: 'Phone Number',
                          hintText: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: (v) {
                            final t = (v ?? '').trim();
                            if (t.isEmpty) return 'Phone number is required';
                            if (!Validators.isPhone(t)) return 'Enter valid 10-digit phone';
                            return null;
                          },
                        ),
                        SizedBox(height: resp.spacing(32)),

                        // Register Button
                        AppButton(
                          label: 'Create Account',
                          loading: controller.loading.value,
                          onPressed: () {
                            controller.name.value = nameCtrl.text.trim();
                            controller.phone.value = phoneCtrl.text.trim();
                            controller.email.value = emailCtrl.text.trim();
                            if (!formKey.currentState!.validate()) return;
                            controller.register();
                          },
                        ),
                        SizedBox(height: resp.spacing(20)),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.divider)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: resp.spacing(16)),
                              child: Text(
                                'or',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.divider)),
                          ],
                        ),
                        SizedBox(height: resp.spacing(20)),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                "Sign In",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ),
              ),
              
              SizedBox(height: resp.spacing(40)),
              
              // Footer
              _buildFooter(resp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Responsive resp) {
    return Column(
      children: [
        // App Logo
        Container(
          width: resp.isTablet ? 80 : 64,
          height: resp.isTablet ? 80 : 64,
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
            size: 32,
          ),
        ),
        SizedBox(height: resp.spacing(20)),
        
        // Header Text
        Text(
          "Join InFly Today",
          style: AppTextStyles.displaySmall.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: resp.spacing(8)),
        Text(
          "Start your influencer journey with us",
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.muted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooter(Responsive resp) {
    return Column(
      children: [
        Text(
          "By creating an account, you agree to our",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.muted,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: resp.spacing(4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Handle terms of service
              },
              child: Text(
                "Terms of Service",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              " and ",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.muted,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle privacy policy
              },
              child: Text(
                "Privacy Policy",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

