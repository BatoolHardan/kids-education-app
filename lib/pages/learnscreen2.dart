import 'package:flutter/material.dart';
import 'package:pro5/Button/close_button.dart';
import 'package:pro5/Button/next_button.dart';
import 'package:pro5/Button/previous_button.dart';
import 'package:pro5/animations/animates_image.dart';
import 'package:pro5/animations/page_sound_controller.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/pages/onboarding/pulsing_screen.dart';
import 'package:pro5/utils/navigation_utils.dart';
import 'package:pro5/pages/HisaDetail/six_model.dart';

class LearnScreen extends StatefulWidget {
  final String title;
  final List<DynamicItem> items;
  final bool fixedBackground;
  final String? fixedBackgroundImage;

  const LearnScreen({
    super.key,
    required this.title,
    required this.items,
    this.fixedBackground = false,
    this.fixedBackgroundImage,
  });

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late final PageController _pageController;
  late final DynamicPageController _controller;
  int _currentIndex = 0;
  late AnimationController _titleAnimationController;
  late AnimationController _descAnimationController;
  late AnimationController _exampleAnimationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _controller = DynamicPageController(
      pageController: _pageController,
      soundManager: SoundManager(),
      items: [],
      dynamicItem: (widget.items),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.playCurrentSound();
    });
  }

  @override
  void dispose() {
    SoundManager.stopAll();
    _pageController.dispose();
    super.dispose();
  }

  void _goToNext() => _controller.next();
  void _goToPrevious() => _controller.previous();

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items[_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child:
                widget.fixedBackground && widget.fixedBackgroundImage != null
                    ? Image.asset(
                      widget.fixedBackgroundImage!,
                      fit: BoxFit.cover,
                    )
                    : Container(color: Theme.of(context).primaryColor),
          ),

          // محتوى الصفحة مع الانيميشن
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الصورة الأولى
                DynamicAnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  childKey: ValueKey(currentItem.hisaImage),
                  child: Image.asset(
                    currentItem.hisaImage,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                // النص الأول
                Card(
                  color: Colors.white.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      currentItem.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                        fontFamily: 'Ghayaty',
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black38,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // النص الثاني (الوصف)
                Card(
                  color: Colors.blueAccent.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      currentItem.desc,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Ghayaty',
                        shadows: [
                          Shadow(
                            blurRadius: 3,
                            color: Colors.black45,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // الصورة الثانية
                DynamicAnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  childKey: ValueKey(currentItem.objectImage),
                  child: Image.asset(
                    currentItem.objectImage,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 5),

                // النص الثالث (المثال)
                Card(
                  color: Colors.greenAccent.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      currentItem.example,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        fontFamily: 'Ghayaty',
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // العنوان الرئيسي
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ghayaty',
                    color: Colors.deepOrange,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // زر الإغلاق
          Positioned(
            top: 40,
            right: 20,
            child: CloseButtonWidget(
              onTap: () async {
                await SoundManager.stopAll();
                Navigator.of(context).pop();
              },
            ),
          ),

          // زر التالي
          Positioned(
            bottom: 30,
            left: 20,
            child: NextButtonWidget(onTap: _goToNext),
          ),

          // زر السابق
          Positioned(
            bottom: 30,
            right: 20,
            child: PreviousButtonWidget(onTap: _goToPrevious),
          ),

          // زر إعادة تشغيل الصوت
          // زر إعادة تشغيل الصوت (دائري + نبض)
          Positioned(
            bottom: 30, // نفس مستوى أزرار السابق والتالي
            left:
                MediaQuery.of(context).size.width / 2 -
                30, // لتوسيطه تمامًا بين الزرين
            child: PulsingWidget(
              child: FloatingActionButton(
                backgroundColor: Colors.orange, // 👈 اللون البرتقالي يجذب الطفل
                onPressed: () => _controller.playCurrentSound(),
                child: const Icon(
                  Icons.volume_up,
                  size: 35,
                  color: Colors.white,
                ), // أيقونة الصوت
              ),
            ),
          ),

          // PageView مخفي للتحكم بالتنقل
          IgnorePointer(
            ignoring: true,
            child: SizedBox(
              height: 0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _controller.goToPage(index);
                  _controller.playCurrentSound();
                },
                itemBuilder: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
