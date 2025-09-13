import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
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

                    AppInput(
                      controller: nameCtrl,
                      label: 'Full Name',
                      validator: (v) {
                        if (!Validators.nonEmpty((v ?? ''))) return 'Name is required';
                        return null;
                      },
                    ),
                    SizedBox(height: context.responsive.spacing(16)),

                    AppInput(
                      controller: phoneCtrl,
                      label: 'Phone (10 digits)',
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (!Validators.isPhone(t)) return 'Enter 10-digit phone';
                        return null;
                      },
                    ),
                    SizedBox(height: context.responsive.spacing(16)),

                    AppInput(
                      controller: emailCtrl,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (!Validators.isEmail(t)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: context.responsive.spacing(20)),

                    AppButton(
                      label: 'Register & Send OTP',
                      loading: controller.loading.value,
                      onPressed: () {
                        controller.name.value  = nameCtrl.text.trim();
                        controller.phone.value = phoneCtrl.text.trim();
                        controller.email.value = emailCtrl.text.trim();
                        if (!formKey.currentState!.validate()) return;
                        controller.register();
                      },
                    ),


                    SizedBox(height: context.responsive.spacing(12)),

                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Already have an account? Login"),
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

