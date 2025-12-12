import 'dart:ui'; // Cần import để dùng hiệu ứng làm mờ (Blur)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/daily_forecast_card.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forecast = context.watch<WeatherProvider>().forecast;

    return Scaffold(
      extendBodyBehindAppBar: true, // Để hình nền tràn lên cả thanh trạng thái
      appBar: AppBar(
        title: const Text(
          "5-Day Forecast",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Trong suốt để thấy nền
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Sử dụng Container với Gradient làm nền tổng thể
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Tông màu "Xẩm" (Xanh đen đậm -> Tím than) giúp icon nổi bật
            colors: [
              Color(0xFF1F2833), // Màu xám xanh đậm
              Color(0xFF0B0C10), // Màu đen gần như tuyệt đối ở dưới
            ],
          ),
        ),
        child: forecast.isEmpty
            ? const Center(
                child: Text(
                  "No forecast data available",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 20), // Top 100 để tránh AppBar
                itemCount: forecast.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12), // Khoảng cách giữa các thẻ
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Bo góc mềm mại
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Làm mờ nền sau thẻ
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8), // Padding bên trong thẻ
                        decoration: BoxDecoration(
                          // MẤU CHỐT: Màu đen nhạt trong suốt (0.3) tạo độ "xẩm"
                          color: Colors.black.withOpacity(0.3), 
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1), // Viền sáng mờ nhẹ cho sang
                            width: 1,
                          ),
                        ),
                        // Lưu ý: DailyForecastCard bên trong chữ phải màu TRẮNG nhé
                        child: DailyForecastCard(forecast: forecast[index]),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}