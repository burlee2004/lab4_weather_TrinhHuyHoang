import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const DailyForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(forecast.dateTime),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                DateFormat('MMM d, h:mm a').format(forecast.dateTime),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          // Icon
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${forecast.icon}.png',
            width: 50,
            height: 50,
          ),
          Text(
            '${forecast.temperature.round()}°',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}