import 'package:flutter/material.dart';

class StageModel {
  final String id;
  final String name; // اسم المرحلة (حروف - أرقام - ...)
  final String animationPath; // أنيميشن التهنئة
  final Widget screen; // شاشة المرحلة التعليمية نفسها

  StageModel({
    required this.id,
    required this.name,
    required this.animationPath,
    required this.screen,
  });
}
