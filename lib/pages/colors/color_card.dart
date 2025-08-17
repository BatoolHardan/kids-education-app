import 'package:flutter/material.dart';
import 'package:pro5/animations/sound_play.dart';
import 'color_item.dart';
import 'colors_list.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});

  @override
  _ColorsScreenState createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen>
    with SingleTickerProviderStateMixin {
  String? selectedImagePath;
  double _opacity = 0.0;
  double _scale = 0.5;
  double _rotation = 0.0;

  Color _backgroundColor = Colors.white;
  Color _shadowColor = Colors.grey;

  void _onColorTap(ColorItem colorItem) {
    // تشغيل الصوت الخاص باللون
    SoundManager.stopAll();
    SoundManager.play(colorItem.sound);

    // الصورة تختفي تدريجياً قبل ظهور الصورة الجديدة
    setState(() {
      _opacity = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        selectedImagePath = colorItem.objectImage;
        _scale = 0.5;
        _rotation = 0.0;
        _backgroundColor = colorItem.backgroundColor;
        _shadowColor = colorItem.shadowColor;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
          _rotation = 0.3;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // تحمّل أصوات الألوان قبل الاستخدام
    final soundPaths =
        colors.where((c) => c.sound != null).map((c) => c.sound).toList();
    SoundManager.preload(soundPaths);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'تعلم الألوان!',
              style: TextStyle(
                fontFamily: 'Ghayaty',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                shadows: const [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.blueAccent,
                    offset: Offset(4.0, 4.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Center(
                child:
                    selectedImagePath != null
                        ? AnimatedOpacity(
                          opacity: _opacity,
                          duration: const Duration(milliseconds: 300),
                          child: AnimatedScale(
                            scale: _scale,
                            duration: const Duration(milliseconds: 400),
                            child: Transform.rotate(
                              angle: _rotation,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _shadowColor.withOpacity(0.7),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  selectedImagePath!,
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                            ),
                          ),
                        )
                        : const Text(
                          'اضغط على لون لرؤية الصورة',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  final colorItem = colors[index];
                  return GestureDetector(
                    onTap: () => _onColorTap(colorItem),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.blueAccent.withOpacity(0.5),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        colorItem.splashImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
