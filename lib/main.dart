import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for orientation
import 'package:get/get.dart';
import 'app_binding.dart';
import 'config/app_pages.dart';
import 'config/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait by default
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Unlock landscape for larger screens (tablet)
      if (constraints.maxWidth >= 600) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }

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
    });
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
    // Navigate to login screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Get.offNamed(Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change background if needed
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
