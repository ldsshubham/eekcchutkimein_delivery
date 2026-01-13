import 'package:flutter/material.dart';

class ImageHelper {
  static ImageProvider safeImage(String? url) {
    if (url == null || url.isEmpty) {
      print("⚠ Using placeholder - URL empty");
      return const AssetImage("assets/no_img.jpg");
    }

    print("📌 Loading image URL: $url");

    return NetworkImage(url);
  }
}
