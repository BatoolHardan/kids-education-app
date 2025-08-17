import 'package:flutter/material.dart';
import 'package:pro5/Button/close_button.dart';
import 'package:pro5/Button/next_button.dart';
import 'package:pro5/Button/previous_button.dart';
import 'package:pro5/animations/animates_image.dart';
import 'package:pro5/animations/page_sound_controller.dart';
import 'package:pro5/animations/sound_play.dart';
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

class _LearnScreenState extends State<LearnScreen>
    with TickerProviderStateMixin {
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
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _descAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _exampleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    // بدء الأنيميشن بعد تأخير بسيط
    Future.delayed(Duration(milliseconds: 300), () {
      _titleAnimationController.forward();
      _descAnimationController.forward();
      _exampleAnimationController.forward();
    });
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

                AnimatedBuilder(
                  animation: _titleAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        (1 - _titleAnimationController.value) * 50,
                      ),
                      child: Opacity(
                        opacity: _titleAnimationController.value,
                        child: Text(
                          currentItem.title,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
                            fontFamily: 'Ghayaty',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // النص الثاني (الوصف)
                AnimatedBuilder(
                  animation: _descAnimationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _descAnimationController.value,
                      child: Opacity(
                        opacity: _descAnimationController.value,
                        child: Text(
                          currentItem.desc,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.yellow,
                            fontFamily: 'Ghayaty',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),

                // النص الثالث (المثال)
                AnimatedBuilder(
                  animation: _exampleAnimationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: (1 - _exampleAnimationController.value) * 0.2,
                      child: Transform.scale(
                        scale: _exampleAnimationController.value,
                        child: Opacity(
                          opacity: _exampleAnimationController.value,
                          child: Text(
                            currentItem.example,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.pinkAccent,
                              fontFamily: 'Ghayaty',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ghayaty',
                    color: Colors.deepOrange,
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
          Positioned(
            bottom: 100,
            right: MediaQuery.of(context).size.width / 2 - 25,
            child: IconButton(
              icon: const Icon(Icons.volume_up, size: 50, color: Colors.orange),
              onPressed: () => _controller.playCurrentSound(),
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
