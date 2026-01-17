import 'package:eekcchutkimein_delivery/constants/app_font_weight.dart';
import 'package:eekcchutkimein_delivery/constants/app_sizes.dart';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: AppSizes.fontXXL,
    fontWeight: AppFontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: AppSizes.fontXL,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.primaryColor,
  );

  static final TextStyle bodyText = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: AppFontWeight.regular,
    color: AppColors.primaryColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: AppFontWeight.light,
    color: AppColors.gray,
  );

  static const TextStyle button = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: AppFontWeight.medium,
    color: AppColors.white,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: AppFontWeight.medium,
    color: AppColors.error,
  );
}
