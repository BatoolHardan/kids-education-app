import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:pro5/pages/onboarding/login_page.dart';
import 'package:pro5/pages/onboarding/onboarding.dart';
import 'package:pro5/pages/onboarding/sign_up_full.dart';

import 'package:pro5/pages/stag_three_four.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await Firebase.initializeApp();
  Get.put(AuthController());
  // مسح حالة الدخول عند كل تشغيل (اختياري)
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);

  runApp(const MyApp());
  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: "Ghayaty",
        textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 18.0)),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class StartDecider extends StatefulWidget {
  const StartDecider({super.key});

  @override
  State<StartDecider> createState() => _StartDeciderState();
}

class _StartDeciderState extends State<StartDecider> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _decideStartScreen();
  }

  Future<void> _decideStartScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isRegistered = prefs.getBool('isRegistered') ?? false;

      if (!isRegistered) {
        Get.off(() => const SignUpUserScreen());
      } else {
        Get.off(() => const WelcomeScreen());
      }
    } catch (e) {
      print('Error: $e');
      Get.off(() => const LoginScreen());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink(),
    );
  }
}
