import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "User";
  String _email = "user@email.com";
  String _imagePath = "";

  String get name => _name;
  String get email => _email;
  String get imagePath => _imagePath;

  // 🔥 LOAD DATA SAAT APP DIBUKA
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('name') ?? "User";
    _email = prefs.getString('email') ?? "user@email.com";
    _imagePath = prefs.getString('image') ?? "";

    notifyListeners();
  }

  // 🔥 SIMPAN DATA
  Future<void> updateProfile(String name, String email, String imagePath) async {
    _name = name;
    _email = email;
    _imagePath = imagePath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('image', imagePath);

    notifyListeners();
  }
}