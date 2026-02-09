import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showErrorToast(String message, {String? subMessage}) {
    toastification.show(
      title: Text(message),
      description: subMessage != null ? Text(subMessage) : null,
      type: ToastificationType.error,
      icon: const Icon(Iconsax.warning_2),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.minimal,
    );
  }

  static void showSuccessToast({required String message, String? subMessage}) {
    toastification.show(
      title: Text(message),
      description: subMessage != null ? Text(subMessage) : null,
      type: ToastificationType.success,
      icon: const Icon(Iconsax.tick_circle),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.minimal,
    );
  }

  static void showWarningToast({required String message, String? subMessage}) {
    toastification.show(
      title: Text(message),
      description: subMessage != null ? Text(subMessage) : null,
      type: ToastificationType.warning,
      icon: const Icon(Iconsax.danger),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.minimal,
    );
  }
}
