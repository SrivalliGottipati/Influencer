import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import 'auth_controller.dart';
import '../../config/app_routes.dart';
import '../../core/utils/validators.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
                child: Obx(() => Form(
                  key: formKey,
                  child: Column(
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

                    /// Country dropdown + phone input
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
                            decoration: const InputDecoration(
                              labelText: "Country",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Phone input
                        Expanded(
                          flex: 4,
                          child: AppInput(
                            controller: phoneCtrl,
                            label: 'Phone',
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              final t = (v ?? '').trim();
                              if (!Validators.isPhone(t)) return 'Enter 10-digit phone';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.responsive.spacing(20)),

                    /// Login Button
                    AppButton(
                      label: 'Send OTP',
                      loading: controller.loading.value,
                      onPressed: () {
                        controller.phone.value = phoneCtrl.text.trim();
                        if (!formKey.currentState!.validate()) return;
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
                ))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
