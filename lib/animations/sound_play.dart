import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class SoundManager {
  static final List<String> _soundPaths = [
    'sounds/الأصوات التشجيعية/إجابة خاطئة.mp3',
    'sounds/الأصوات التشجيعية/حاول مرة أخرى.mp3',
    'sounds/الأصوات التشجيعية/فكر جيدا.mp3',
    'sounds/الأصوات التشجيعية/لاتيأس.mp3',
  ];
  static bool _isPreloaded = false;

  static final _sounds = [
    'sounds/الأصوات التشجيعية/ماشاء الله.mp3',
    'sounds/الأصوات التشجيعية/ممتازة.mp3',
    'sounds/الأصوات التشجيعية/رائعة.mp3',
  ];

  static final AudioPlayer _player = AudioPlayer();

  // static final Map<String, AssetSource> _cache = {};
  static StreamSubscription<void>? _navigationSub;

  static Future<void> playRandomCorrectSound() async {
    final randomIndex = Random().nextInt(_sounds.length);
    await _player.play(AssetSource(_sounds[randomIndex]));
  }

  static int _lastIndex = -1;

  static Future<void> playRandomWrongSound() async {
    int randomIndex;
    do {
      randomIndex = Random().nextInt(_soundPaths.length);
    } while (randomIndex == _lastIndex && _soundPaths.length > 1);

    _lastIndex = randomIndex;
    await _player.play(AssetSource(_soundPaths[randomIndex]));
  }

  static Future<void> preload(List<String?> soundPaths) async {
    if (_isPreloaded) return;
    for (var path in soundPaths) {
      if (path != null) {
        try {
          await _player.setSource(AssetSource(path));
        } catch (e) {
          debugPrint("Error preloading $path: $e");
        }
      }
    }
    _isPreloaded = true;
  }

  static Future<void> play(String soundPath) async {
    try {
      // await _player.stop();
      final source =
          // _cache[soundPath] ??
          AssetSource(soundPath.replaceFirst('assets/', ''));
      await _player.setSource(source);
      await _player.play(source);
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  static Future<void> stopAll() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }

  /// Pop sound (خاص)
  static AudioPlayer? _popPlayer;
  static Future<void> playPopSound() async {
    try {
      _popPlayer ??= AudioPlayer();
      await _popPlayer!.stop();
      await _popPlayer!.play(
        AssetSource('sounds/hello_sound/ding-cartoon.mp3'),
      );
    } catch (e) {
      debugPrint('Error playing pop sound: $e');
    }
  }

  static Future<void> playAndNavigate(String soundPath, Widget page) async {
    await stopAll(); // وقف أي صوت شغال

    // إلغاء أي مستمع قديم
    await _navigationSub?.cancel();

    await _player.play(AssetSource(soundPath.replaceFirst('assets/', '')));

    // أضف مستمع جديد
    _navigationSub = _player.onPlayerComplete.listen((_) {
      if (Get.context != null) {
        Get.to(
          () => page,
          transition: Transition.zoom,
          preventDuplicates: false,
        );
      }
    });
  }
}
