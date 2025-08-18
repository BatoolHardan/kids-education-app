import 'package:flutter/material.dart';

class PulsingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double lowerBound;
  final double upperBound;

  const PulsingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.lowerBound = 0.9,
    this.upperBound = 1.1,
  });

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.lowerBound,
      end: widget.upperBound,
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
