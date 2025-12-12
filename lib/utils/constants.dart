// lib/utils/constants.dart

import 'package:flutter/material.dart';

class AppConstants {
  static const double defaultPadding = 20.0;
  static const double cardRadius = 20.0;
  
  // Default City
  static const String defaultCity = 'Hanoi';
  
  // Error Messages
  static const String errorNoData = 'No weather data available';
  static const String errorNoInternet = 'No internet connection';
  static const String errorLocation = 'Location permission denied';
  
  static const Color colorSunnyPrimary = Color(0xFFFDB813);
  static const Color colorSunnyBg = Color(0xFF87CEEB);
  
  static const Color colorRainyPrimary = Color(0xFF4A5568);
  static const Color colorRainyBg = Color(0xFF718096);
  
  static const Color colorCloudyPrimary = Color(0xFFA0AEC0);
  static const Color colorCloudyBg = Color(0xFFCBD5E0);
  
  static const Color colorNightPrimary = Color(0xFF2D3748);
  static const Color colorNightBg = Color(0xFF1A202C);
}