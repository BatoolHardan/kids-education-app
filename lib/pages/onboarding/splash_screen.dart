import 'package:flutter/material.dart';
import 'package:pro5/pages/onboarding/login_page.dart';
import 'package:pro5/pages/onboarding/data_kide_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartDecider extends StatefulWidget {
  const StartDecider({super.key});

  @override
  State<StartDecider> createState() => _StartDeciderState();
}

class _StartDeciderState extends State<StartDecider> {
  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool('isRegistered') ?? false;

    if (isRegistered) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DataKideScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // واجهة مؤقتة تظهر أثناء التحميل
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
