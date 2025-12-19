import 'dart:convert';

import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/features/homepage/model/dashboard_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DashboardApi {
  final storage = FlutterSecureStorage();
  Future<DashboardModel> fetchDashboardDetails() async {
    final String? token = await storage.read(key: "accessToken");
    final String url = '${AppString.baseUrl}vendor/dashboard';

    try {
      print('Dashboard APi is beingh called');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        return DashboardModel.fromJson(jsonData['data']);
      } else {
        print('Failed to fetch dashboard details');
        throw Exception('Failed to load dashboard details');
      }
    }
    // Catch Statement
    catch (e) {
      throw Exception('This is the error in dashboard fetch $e');
    }
  }
}
