import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showErrorToast({required String message}) {
    toastification.show(
      title: Text(message),
      type: ToastificationType.error,
      icon: const Icon(Iconsax.warning_2),
      autoCloseDuration: Duration(seconds: 2),
      style: ToastificationStyle.minimal,
    );
  }

  static void showSuccessToast({required String message}) {
    toastification.show(
      title: Text(message),
      type: ToastificationType.success,
      icon: const Icon(Iconsax.tick_circle),
      autoCloseDuration: Duration(seconds: 2),
      style: ToastificationStyle.minimal,
    );
  }

  static void showWarningToast({required String message}) {
    toastification.show(
      title: Text(message),
      type: ToastificationType.warning,
      icon: const Icon(Iconsax.danger),
      autoCloseDuration: Duration(seconds: 2),
      style: ToastificationStyle.minimal,
    );
  }
}
