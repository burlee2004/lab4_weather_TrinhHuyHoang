import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    // 1. Tính toán Nhiệt độ
    double temp = weather.temperature;
    double feelsLike = weather.feelsLike;
    if (!settings.isCelsius) {
      temp = (temp * 9 / 5) + 32;
      feelsLike = (feelsLike * 9 / 5) + 32;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            DateFormatter.formatFullDate(weather.dateTime),
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
            width: 120,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(
            '${weather.temperature.round()}°',
            style: TextStyle(fontSize: 80, fontWeight: FontWeight.w300, color: Colors.white),
          ),
          Text(
            weather.description.toUpperCase(),
            style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 2),
          ),
          Text(
             'Feels like ${weather.feelsLike.round()}°',
             style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}