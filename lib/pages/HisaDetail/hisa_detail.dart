import 'package:flutter/material.dart';
import 'package:pro5/Button/close_button.dart';
import 'package:pro5/Button/next_button.dart';
import 'package:pro5/Button/previous_button.dart';
import 'package:pro5/animations/animates_image.dart';
import 'package:pro5/animations/page_sound_controller.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/utils/navigation_utils.dart';
import 'package:pro5/pages/HisaDetail/six_model.dart';

class AnimatedPagesScreen extends StatefulWidget {
  final String title;
  final List<DynamicItem> items;
  final bool fixedBackground;
  final String? fixedBackgroundImage;

  const AnimatedPagesScreen({
    super.key,
    required this.title,
    required this.items,
    this.fixedBackground = false,
    this.fixedBackgroundImage,
  });

  @override
  State<AnimatedPagesScreen> createState() => _AnimatedPagesScreenState();
}

class _AnimatedPagesScreenState extends State<AnimatedPagesScreen> {
  late final PageController _pageController;
  late final SoundManager _soundManager;
  late final DynamicPageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _controller = DynamicPageController(
      pageController: _pageController,
      soundManager: _soundManager,
      items: _convertDynamicItemsToMaps(widget.items),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.playCurrentSound();
    });
  }

  List<Map<String, dynamic>> _convertDynamicItemsToMaps(
    List<DynamicItem> items,
  ) {
    return items
        .map(
          (item) => {
            'title': item.title,
            'desc': item.desc,
            'image': item.hisaImage,
            'exampleImage': item.objectImage,
            'exampleText': item.example,
            'sound': item.soundPath, // تأكد من وجود soundPath في DynamicItem
          },
        )
        .toList();
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
                Text(
                  currentItem.title,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                    fontFamily: 'Ghayaty',
                  ),
                ),
                const SizedBox(height: 10),

                // النص الثاني (الوصف)
                Text(
                  currentItem.desc,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.yellow,
                    fontFamily: 'Ghayaty',
                  ),
                ),
                const SizedBox(height: 30),

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
                Text(
                  currentItem.example,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.pinkAccent,
                    fontFamily: 'Ghayaty',
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
              icon: const Icon(Icons.volume_up, size: 50, color: Colors.white),
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
