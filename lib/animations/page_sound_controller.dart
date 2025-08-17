import 'package:flutter/material.dart';
import 'package:pro5/animations/sound_play.dart';
import 'package:pro5/pages/HisaDetail/six_model.dart';
import 'package:pro5/pages/arabic_letters/letter_data.dart';

class DynamicPageController {
  final PageController pageController;
  final SoundManager soundManager;
  final List<Item> items;
  final List<DynamicItem>? dynamicItem;
  int currentIndex = 0;

  DynamicPageController({
    required this.pageController,
    required this.soundManager,
    required this.items,
    required this.dynamicItem,
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

  void playCurrentSound() async{
    final soundPath = items[currentIndex].sound;
      // await SoundManager.stopAll();
      SoundManager.play(soundPath);
  }
}
