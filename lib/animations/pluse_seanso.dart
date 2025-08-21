import 'package:flutter/material.dart';

class PulseSeasonDragSelector extends StatefulWidget {
  final List<Map<String, String>> seasons;
  final Function(String season, bool correct) onDrop;

  const PulseSeasonDragSelector({
    required this.seasons,
    required this.onDrop,
    super.key,
  });

  @override
  _PulseSeasonDragSelectorState createState() =>
      _PulseSeasonDragSelectorState();
}

class _PulseSeasonDragSelectorState extends State<PulseSeasonDragSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Map<String, String>> shuffledSeasons;

  @override
  void initState() {
    super.initState();
    shuffledSeasons = List.from(widget.seasons)..shuffle();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shuffledSeasons.length,
        itemBuilder: (context, index) {
          final season = shuffledSeasons[index];
          final name = season['name']!;
          final imagePath = season['image']!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ScaleTransition(
              scale: _animation,
              child: Draggable<String>(
                data: name, // الآن data هو اسم الموسم
                feedback: Image.asset(imagePath, width: 80, height: 80),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: Image.asset(imagePath, width: 80, height: 80),
                ),
                child: Image.asset(imagePath, width: 80, height: 80),
              ),
            ),
          );
        },
      ),
    );
  }
}
