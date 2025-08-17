import 'package:flutter/material.dart';
import 'package:pro5/animations/sound_play.dart';

class DynamicPageController {
  final PageController pageController;
  final SoundManager soundManager;
  final List<Map<String, dynamic>> items;
  int currentIndex = 0;

  DynamicPageController({
    required this.pageController,
    required this.soundManager,
    required this.items,
  });

  void goToPage(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
  }

  void next({VoidCallback? onLastPage}) {
    if (currentIndex < items.length - 1) {
      currentIndex++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      playCurrentSound();
    } else {
      if (onLastPage != null) onLastPage();
    }
  }

  void previous() {
    if (currentIndex > 0) {
      currentIndex--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      playCurrentSound();
    }
  }

  void playCurrentSound() {
    final soundPath = items[currentIndex]['sound'];
    if (soundPath != null) {
      SoundManager.stopAll();
      SoundManager.play(soundPath);
    }
  }
}
