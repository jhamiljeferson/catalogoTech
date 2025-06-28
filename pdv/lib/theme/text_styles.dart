import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const body = TextStyle(fontSize: 14, color: AppColors.textPrimary);
}
