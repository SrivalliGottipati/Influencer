import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/text_styles.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'auth_controller.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final otpCtrl = TextEditingController();
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
              
              // OTP Form
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: AppCard(
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: resp.spacing(8)),
                      Text(
                        "Enter the 6-digit OTP",
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.muted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: resp.spacing(8)),
                      // Text(
                      //   "+91 ${controller.phone.value}",
                      //   style: AppTextStyles.bodyMedium.copyWith(
                      //     color: AppColors.primary,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(height: resp.spacing(32)),

                      // OTP Input
                      AppInput(
                        controller: otpCtrl,
                        label: 'Enter OTP',
                        hintText: '000000',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.security,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (value) {
                          if (value.length == 6) {
                            // Auto-verify when 6 digits are entered
                            controller.otp.value = value;
                            controller.verifyOtp();
                          }
                        },
                      ),
                      SizedBox(height: resp.spacing(24)),

                      // Verify Button
                      AppButton(
                        label: 'Verify OTP',
                        loading: controller.loading.value,
                        onPressed: () {
                          controller.otp.value = otpCtrl.text.trim();
                          if (otpCtrl.text.trim().length != 6) {
                            Get.snackbar(
                              'Error',
                              'Please enter 6-digit OTP',
                              backgroundColor: AppColors.dangerLighter,
                              colorText: AppColors.danger,
                            );
                            return;
                          }
                          controller.verifyOtp();
                        },
                      ),
                      SizedBox(height: resp.spacing(20)),

                      // Resend option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the OTP? ",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.sendLoginOtp(),
                            child: Text(
                              "Resend",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: resp.spacing(16)),

                      // Timer
                      Obx(() => Text(
                        "Resend OTP in ${controller.resendTimer.value}s",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.muted,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ],
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
        // OTP Icon
        Container(
          width: resp.isTablet ? 80 : 64,
          height: resp.isTablet ? 80 : 64,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.verified_user,
            color: Colors.white,
            size: 32,
          ),
        ),
        SizedBox(height: resp.spacing(20)),
        
        // Header Text
        Text(
          "Verify Your Phone",
          style: AppTextStyles.displaySmall.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: resp.spacing(8)),
        Text(
          "We've sent a verification code to your phone",
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
          "Having trouble receiving the OTP?",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.muted,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: resp.spacing(8)),
        GestureDetector(
          onTap: () {
            // Handle contact support
          },
          child: Text(
            "Contact Support",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
