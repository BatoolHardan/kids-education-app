import 'package:flutter/material.dart';
import 'package:pro5/Button/close_button.dart';
import 'package:pro5/Button/next_button.dart';
import 'package:pro5/Button/previous_button.dart';
import 'package:pro5/animations/animates_image.dart';
import 'package:pro5/animations/page_sound_controller.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/pages/arabic_letters/letter_data.dart';
import 'package:pro5/utils/navigation_utils.dart';

class LearningScreen extends StatefulWidget {
  final String title;
  final List<Item> items;
  final bool fixedBackground;
  final String? fixedBackgroundImage;

  const LearningScreen({
    super.key,
    required this.title,
    required this.items,
    this.fixedBackground = false,
    this.fixedBackgroundImage,
  });

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final PageController _pageController;
  late final DynamicPageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controller = DynamicPageController(
      dynamicItem: null,
      pageController: _pageController,
      soundManager: SoundManager(),
      items: widget.items,
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

  void _goToNext() { _controller.next();}
 
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
                    : Container(color: currentItem.color ?? Colors.white),
          ),

          // محتوى الصفحة مع الانيميشن
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DynamicAnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  childKey: ValueKey(currentItem.image),
                  child: Image.asset(
                    currentItem.image,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  currentItem.word ?? '',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Ghayaty',
                  ),
                ),
                const SizedBox(height: 30),
                // if (currentItem['exampleImage'] != null)
                //   DynamicAnimatedSwitcher(
                //     duration: const Duration(milliseconds: 600),
                //     childKey: ValueKey(currentItem['exampleImage']),
                //     child: Image.asset(
                //       currentItem['exampleImage'],
                //       height: 120,
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // if (currentItem['exampleText'] != null) ...[
                //   const SizedBox(height: 10),
                //   Text(
                //     currentItem['exampleText']!,
                //     style: const TextStyle(
                //       fontSize: 24,
                //       color: Colors.white,
                //       fontFamily: 'Ghayaty',
                //     ),
                //   ),
                // ],
              ],
            ),
          ),

          // العنوان
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
                    color: Colors.black,
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
                closeScreen(context);
              },
            ),
          ),

          // زر التالي
          Positioned(
            bottom: 30,
            left: 20,
            child: _currentIndex==widget.items.length-1? Text('') :NextButtonWidget(onTap: _goToNext),
          ),

          // زر السابق
          Positioned(
            bottom: 30,
            right: 20,
            child: _currentIndex==0? Text('') : PreviousButtonWidget(onTap: _goToPrevious),
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

