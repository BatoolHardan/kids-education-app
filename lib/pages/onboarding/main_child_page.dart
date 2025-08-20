import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pro5/pages/exames/tests_screen.dart';
import 'package:pro5/pages/onboarding/data_kide_page.dart';
import 'package:pro5/pages/onboarding/pulsing_screen.dart';
import 'package:pro5/pages/stag_three_four.dart'; // تأكد من صحة المسار

class MainChildPage extends StatelessWidget {
  const MainChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الأطفال',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ghayaty',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          titleMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const MainChildScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainChildScreen extends StatelessWidget {
  const MainChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // بدل ما يخرج من التطبيق، نرجع لصفحة معينة باستخدام GetX
        Get.off(() => const DataKideScreen());
        return false; // منع الرجوع الافتراضي
      },
      child: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    'مرحباً بك!',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.blue[800],
                      fontFamily: 'Ghayaty',
                    ),
                  ),
                ),
              ),

              // Subtitle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                child: Text(
                  'اختر ما تريد تعلمه اليوم',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blue[600],
                    fontFamily: 'Ghayaty',
                  ),
                ),
              ),

              // Circles with Pulsing Effect
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      right: 50,
                      child: PulsingWidget(
                        child: AnimatedCircle(
                          icon: Icons.school,
                          color: Colors.blueAccent,
                          label: 'التعلم',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const StageThreeFourScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 50,
                      child: PulsingWidget(
                        child: AnimatedCircle(
                          icon: Icons.games,
                          color: Colors.pinkAccent,
                          label: 'الاختبارات',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        TestsScreen(), // هنا الصفحة المطلوبة
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const AnimatedCircle({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.9), color.withOpacity(0.5)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(child: Icon(icon, size: 50, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Ghayaty',
          ),
        ),
      ],
    );
  }
}
