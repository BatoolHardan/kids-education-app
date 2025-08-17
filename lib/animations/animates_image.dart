import 'dart:ui';

import 'package:flutter/material.dart';

class DualAnimationWrapper extends StatelessWidget {
  final int currentIndex;
  final Duration containerDuration;
  final Duration switcherDuration;
  final Color Function(int)? colorBuilder;
  final Widget Function(int) childBuilder;
  final Curve containerCurve;
  final Curve switcherCurve;

  const DualAnimationWrapper({
    super.key,
    required this.currentIndex,
    this.containerDuration = const Duration(milliseconds: 500),
    this.switcherDuration = const Duration(milliseconds: 500),
    required this.colorBuilder,
    required this.childBuilder,
    this.containerCurve = Curves.easeInOut,
    this.switcherCurve = Curves.easeInOut,
    required void Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicAnimatedContainer(
      currentIndex: currentIndex,
      duration: containerDuration,
      colorBuilder: colorBuilder,
      curve: containerCurve,
      child: DynamicAnimatedSwitcher(
        duration: switcherDuration,
        childKey: ValueKey(currentIndex),
        child: childBuilder(currentIndex),
      ),
    );
  }
}

class DynamicAnimatedContainer extends StatefulWidget {
  final Duration duration;
  final Color Function(int)? colorBuilder;
  final Curve curve;
  final Widget child;
  final int currentIndex;

  const DynamicAnimatedContainer({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    required this.colorBuilder,
    this.curve = Curves.easeInOut,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<DynamicAnimatedContainer> createState() =>
      _DynamicAnimatedContainerState();
}

class _DynamicAnimatedContainerState extends State<DynamicAnimatedContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      color: widget.colorBuilder?.call(widget.currentIndex) ?? Colors.white,
      curve: widget.curve,
      child: widget.child,
    );
  }
}

class DynamicAnimatedSwitcher extends StatelessWidget {
  final Duration duration;
  final Widget Function(Widget child, Animation<double> animation)
  transitionBuilder;
  final Widget child;
  final Key? childKey;

  const DynamicAnimatedSwitcher({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.transitionBuilder = _defaultTransitionBuilder,
    required this.child,
    this.childKey,
  });

  static Widget _defaultTransitionBuilder(
    Widget child,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: transitionBuilder,
      child: KeyedSubtree(key: childKey ?? ValueKey(child), child: child),
    );
  }
}
