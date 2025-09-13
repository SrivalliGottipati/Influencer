import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/text_styles.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'auth_controller.dart';
import '../../config/app_routes.dart';
import '../../core/utils/validators.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final resp = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(resp.spacing(24)),
          child: Column(
            children: [
              SizedBox(height: resp.spacing(40)),
              
              // Logo and Welcome Section
              _buildWelcomeSection(resp),
              
              SizedBox(height: resp.spacing(48)),
              
              // Login Form
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: AppCard(
                  child: Obx(() => Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text(
                        //   "Welcome Back",
                        //   style: AppTextStyles.headlineLarge.copyWith(
                        //     fontWeight: FontWeight.w700,
                        //     color: AppColors.ink,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                        SizedBox(height: resp.spacing(8)),
                        Text(
                          "Sign in",
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: resp.spacing(32)),

                        // Country Code and Phone Input
                        Row(
                          children: [
                            // Country dropdown
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                value: controller.countryCode.value,
                                items: const [
                                  DropdownMenuItem(
                                    value: '91',
                                    child: Text("+91"),
                                  ),
                                  DropdownMenuItem(
                                    value: '1',
                                    child: Text("+1"),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) controller.countryCode.value = val;
                                },
                                decoration: InputDecoration(
                                  labelText: "Country",
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.border),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.muted),
                                ),
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                            SizedBox(width: resp.spacing(12)),

                            // Phone input
                            Expanded(
                              flex: 4,
                              child: AppInput(
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
                            ),
                          ],
                        ),
                        SizedBox(height: resp.spacing(24)),

                        // Login Button
                        AppButton(
                          label: 'Send OTP',
                          loading: controller.loading.value,
                          onPressed: () {
                            controller.phone.value = phoneCtrl.text.trim();
                            if (!formKey.currentState!.validate()) return;
                            controller.sendLoginOtp();
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

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.register),
                              child: Text(
                                "Sign Up",
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

  Widget _buildWelcomeSection(Responsive resp) {
    return Column(
      children: [
        // App Logo
        Container(
          width: resp.isTablet ? 100 : 80,
          height: resp.isTablet ? 100 : 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.video_collection,
            color: Colors.white,
            size: 40,
          ),
        ),
        SizedBox(height: resp.spacing(24)),
        
        // Welcome Text
        Text(
          "Welcome to InFly",
          style: AppTextStyles.displaySmall.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: resp.spacing(8)),
        Text(
          "Your gateway to influencer success",
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
          "By continuing, you agree to our",
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
