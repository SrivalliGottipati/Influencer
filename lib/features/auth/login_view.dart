import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import 'auth_controller.dart';
import '../../config/app_routes.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneCtrl = TextEditingController();

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
                      "Welcome Back",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsive.spacing(8)),
                    Text(
                      "Login to continue",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsive.spacing(24)),

                    /// Phone Input
                    AppInput(
                      controller: phoneCtrl,
                      label: 'Phone (10 digits)',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: context.responsive.spacing(20)),

                    /// Login Button
                    AppButton(
                      label: 'Send OTP',
                      loading: controller.loading.value,
                      onPressed: () {
                        controller.phone.value = phoneCtrl.text.trim();
                        controller.sendLoginOtp();
                      },
                    ),
                    SizedBox(height: context.responsive.spacing(12)),

                    /// Register link
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.register),
                      child: const Text("New user? Register"),
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
