// pressable_card.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pro5/animations/sound_play.dart';

class PressableCard extends StatefulWidget {
  final String title;
  final String backgroundImage;
  final Color borderColor;
  final Widget page;
  final AudioPlayer player;
  final bool isDarkMode;
  final String soundPath;

  const PressableCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.borderColor,
    required this.page,
    required this.player,
    required this.isDarkMode,
    required this.soundPath,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with TickerProviderStateMixin {
  late AnimationController _iconPulseController;

  @override
  void initState() {
    super.initState();
    _iconPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await SoundManager.play(widget.soundPath);
        await SoundManager.player.onPlayerComplete.first;

        Navigator.push(context, MaterialPageRoute(builder: (_) => widget.page));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widget.borderColor, width: 3),
          color: widget.isDarkMode ? Colors.grey[900] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!widget.isDarkMode)
                Image.asset(widget.backgroundImage, fit: BoxFit.cover),
              Container(
                color:
                    widget.isDarkMode
                        ? Colors.black.withOpacity(0.7)
                        : Colors.black.withOpacity(0.3),
              ),
              Center(
                child: ScaleTransition(
                  scale: _iconPulseController,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
