import 'package:flutter/material.dart';

class SlideInCard extends StatefulWidget {
  final Widget child;
  final bool fromRight; // true: ييجي من اليمين، false: من اليسار
  final int delayMilliseconds; // تأخير تشغيل الانيميشن
  final Duration duration; // مدة الانيميشن

  const SlideInCard({
    super.key,
    required this.child,
    this.fromRight = true,
    this.delayMilliseconds = 0,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<SlideInCard> createState() => _SlideInCardState();
}

class _SlideInCardState extends State<SlideInCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<Offset>(
      begin: Offset(widget.fromRight ? 1 : -1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // بدء الانيميشن بعد التأخير المحدد
    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
