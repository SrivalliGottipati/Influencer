import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import 'auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
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
                      "Create Account",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsive.spacing(8)),
                    Text(
                      "Fill in your details to get started",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsive.spacing(24)),

                    /// Full Name
                    AppInput(
                      controller: nameCtrl,
                      label: 'Full Name',
                    ),
                    SizedBox(height: context.responsive.spacing(16)),

                    /// Phone
                    AppInput(
                      controller: phoneCtrl,
                      label: 'Phone (10 digits)',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: context.responsive.spacing(20)),

                    /// Register Button
                    AppButton(
                      label: 'Register & Send OTP',
                      loading: controller.loading.value,
                      onPressed: () {
                        controller.name.value = nameCtrl.text.trim();
                        controller.phone.value = phoneCtrl.text.trim();
                        controller.register();
                      },
                    ),

                    SizedBox(height: context.responsive.spacing(12)),

                    /// Already have an account
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Already have an account? Login"),
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
