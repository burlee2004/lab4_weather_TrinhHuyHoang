// lib/providers/settings_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Các biến trạng thái
  bool _isCelsius = true;
  bool _isDarkTheme = false;
  bool _isMsSpeed = true; // true = m/s, false = km/h
  bool _is24HourFormat = true;

  // Getters
  bool get isCelsius => _isCelsius;
  bool get isDarkTheme => _isDarkTheme;
  bool get isMsSpeed => _isMsSpeed;
  bool get is24HourFormat => _is24HourFormat;

  // Keys để lưu vào SharedPreferences
  static const String keyCelsius = 'key_celsius';
  static const String keyDarkTheme = 'key_dark_theme';
  static const String keyMsSpeed = 'key_ms_speed';
  static const String key24Hour = 'key_24_hour';

  SettingsProvider() {
    loadSettings();
  }

  // Load cài đặt từ máy
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isCelsius = prefs.getBool(keyCelsius) ?? true;
    _isDarkTheme = prefs.getBool(keyDarkTheme) ?? false;
    _isMsSpeed = prefs.getBool(keyMsSpeed) ?? true;
    _is24HourFormat = prefs.getBool(key24Hour) ?? true;
    notifyListeners();
  }

  // Toggle Nhiệt độ
  void toggleTemperature(bool value) async {
    _isCelsius = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyCelsius, value);
  }

  // Toggle Theme
  void toggleTheme(bool value) async {
    _isDarkTheme = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkTheme, value);
  }

  // Toggle Đơn vị gió
  void toggleWindSpeed(bool value) async {
    _isMsSpeed = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyMsSpeed, value);
  }

  // Toggle Định dạng giờ
  void toggleTimeFormat(bool value) async {
    _is24HourFormat = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key24Hour, value);
  }

  // --- TÍNH NĂNG MỚI: Khôi phục cài đặt gốc ---
  Future<void> resetSettings() async {
    _isCelsius = true;
    _isDarkTheme = false;
    _isMsSpeed = true;
    _is24HourFormat = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa sạch dữ liệu lưu trong máy
  }
}