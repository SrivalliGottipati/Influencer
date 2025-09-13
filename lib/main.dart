import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_binding.dart';
import 'core/services/secure_store.dart';
import 'config/app_pages.dart';
import 'config/app_routes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Lock orientation to portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint("⚠️ Orientation lock failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'InFly',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      getPages: [
        ...AppPages.routes,
        GetPage(name: Routes.splash, page: () => const SplashScreen()),
      ],
      initialBinding: AppBinding(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideStartRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

Future<void> _decideStartRoute() async {
  // Small splash delay
  await Future.delayed(const Duration(milliseconds: 800));

  try {
    final store = Get.find<SecureStore>();
    final savedPhone = await store.getPhone();
    final savedUserId = await store.getUserId();

    if ((savedPhone != null && savedPhone.isNotEmpty) ||
        (savedUserId != null && savedUserId.isNotEmpty)) {
      Get.offAllNamed(Routes.shell);
      return;
    }
  } catch (e) {
    debugPrint('⚠️ Auto-login check failed: $e');
  }

  Get.offAllNamed(Routes.login);
}

