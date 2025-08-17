import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'season_details_page.dart';

class SeasonsHomePage extends StatefulWidget {
  const SeasonsHomePage({super.key});

  @override
  State<SeasonsHomePage> createState() => _SeasonsHomePageState();
}

class _SeasonsHomePageState extends State<SeasonsHomePage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> seasons = [
    {
      'name': 'الربيع',
      'image': 'assets/images/الفصول الأربعة/ربيع.jpg',
      'color': Colors.greenAccent,
    },
    {
      'name': 'الصيف',
      'image': 'assets/images/الفصول الأربعة/صيف.jpg',
      'color': Colors.orangeAccent,
    },
    {
      'name': 'الخريف',
      'image': 'assets/images/الفصول الأربعة/خريف.jpg',
      'color': Colors.brown,
    },
    {
      'name': 'الشتاء',
      'image': 'assets/images/الفصول الأربعة/شتاء.jpg',
      'color': Colors.lightBlueAccent,
    },
  ];

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20), // كل دورة تاخد 20 ثانية
    )..repeat(); // دوران مستمر
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/images/الفصول الأربعة/خلفية.jpg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'الفصول الأربعة',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationController.value * 2 * pi,
                            child: Stack(
                              children: List.generate(seasons.length, (index) {
                                final season = seasons[index];
                                final angle = (2 * pi / seasons.length) * index;

                                return Transform.rotate(
                                  angle: angle,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => SeasonDetailsPage(
                                            name: season['name'],
                                            image: season['image'],
                                            color: season['color'],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: season['color'].withOpacity(
                                            0.8,
                                          ),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(season['image']),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              season['color'].withOpacity(0.4),
                                              BlendMode.dstATop,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Transform.rotate(
                                          angle: -angle,
                                          child: Text(
                                            season['name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
