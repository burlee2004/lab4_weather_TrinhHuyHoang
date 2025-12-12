import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';
import 'package:provider/provider.dart';
// 2. Import các file nội bộ
import '../models/hourly_weather_model.dart';
import '../providers/settings_provider.dart'; // <-- Để hiểu SettingsProvider là gì
import '../utils/date_formatter.dart';        // <-- Để hiểu DateFormatter là gì
import '../utils/weather_icons.dart';         // <-- Nên dùng cái này để lấy ảnh thống nhất
class HourlyForecastList extends StatelessWidget {
  final List<HourlyWeatherModel> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length > 8 ? 8 : forecasts.length, // Chỉ hiện 24h (8 mốc x 3h)
        itemBuilder: (context, index) {
          final item = forecasts[index];
          final settings = context.watch<SettingsProvider>();
          return Container(
            width: 100,
            margin: EdgeInsets.only(right: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormatter.formatTime(item.dateTime, is24Hour: settings.is24HourFormat),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                CachedNetworkImage(
                  imageUrl: 'https://openweathermap.org/img/wn/${item.icon}.png',
                  width: 40,
                  height: 40,
                ),
                Text(
                  '${item.temperature.round()}°',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}