import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import 'auth_controller.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final otpCtrl = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.responsive.spacing(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.responsive.spacing(20)),
                child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Verify OTP",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsive.spacing(8)),
                    Text(
                      "Enter the 6-digit OTP sent to your phone",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsive.spacing(24)),

                    /// OTP Input
                    AppInput(
                      controller: otpCtrl,
                      label: 'OTP',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: context.responsive.spacing(20)),

                    /// Verify Button
                    AppButton(
                      label: 'Verify',
                      loading: controller.loading.value,
                      onPressed: () {
                        controller.otp.value = otpCtrl.text.trim();
                        controller.verifyOtp();
                      },
                    ),

                    SizedBox(height: context.responsive.spacing(12)),

                    /// Resend option
                    TextButton(
                      onPressed: () => controller.sendLoginOtp(),
                      child: const Text("Didn’t get the OTP? Resend"),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
