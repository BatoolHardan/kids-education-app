import 'package:flutter/material.dart';

class PreviousButtonWidget extends StatefulWidget {
  final VoidCallback onTap;

  const PreviousButtonWidget({super.key, required this.onTap});

  @override
  _PreviousButtonWidgetState createState() => _PreviousButtonWidgetState();
}

class _PreviousButtonWidgetState extends State<PreviousButtonWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 1.2),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Image.asset(
          'assets/images/Icons/arrow_right.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
