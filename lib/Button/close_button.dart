import 'package:flutter/material.dart';
import '../utils/navigation_utils.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const CloseButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => closeScreen(context),
      child: Image.asset(
        'assets/images/Icons/delete.png',
        width: 40,
        height: 40,
      ),
    );
  }
}
