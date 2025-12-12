// lib/models/hourly_weather_model.dart

class HourlyWeatherModel {
  final DateTime dateTime;
  final double temperature;
  final String icon;
  final String description;

  HourlyWeatherModel({
    required this.dateTime,
    required this.temperature,
    required this.icon,
    required this.description,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
    );
  }
}