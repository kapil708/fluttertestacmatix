import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  String user = "User";

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(user, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(user);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return null;
    }
  }
}
