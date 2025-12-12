// lib/screens/home_screen.dart

import 'dart:ui'; // Import để dùng ImageFilter cho hiệu ứng mờ kính
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import Constants
import '../utils/constants.dart';

import '../providers/weather_provider.dart';
import '../models/weather_model.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'settings_screen.dart';
// import provider
import './../providers/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi API lấy thời tiết ngay khi vào app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  // --- PHẦN CHỈNH SỬA MÀU SẮC NGHỆ THUẬT (MOOD) ---
  LinearGradient _getBackgroundGradient(String? condition) {
  // Lấy cài đặt hiện tại
  final settings = context.watch<SettingsProvider>();

  // ƯU TIÊN 1: Nếu User bật Dark Theme -> Trả về màu tối luôn
  if (settings.isDarkTheme) {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF232526), Color(0xFF414345)], // Màu xám đen nghệ thuật
    );
  }

  // ƯU TIÊN 2: Nếu không bật Dark Theme -> Trả về màu theo thời tiết (Code cũ)
  if (condition == null) {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
    );
  }

  switch (condition.toLowerCase()) {
    case 'clear':
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFFFAB00), Color(0xFF4FA8F6), Color(0xFF00CDAC)],
        stops: [0.0, 0.5, 1.0],
      );
    // ... (Giữ nguyên các case còn lại như code tôi gửi lần trước) ...
    case 'rain':
    case 'drizzle':
    case 'thunderstorm':
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF232526), Color(0xFF414345)],
      );
    // ...
    default:
      int hour = DateTime.now().hour;
      if (hour < 6 || hour > 18) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141E30), Color(0xFF243B55)],
        );
      }
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2BC0E4), Color(0xFFEAECC6)],
      );
  }
}

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true, // Để nền tràn lên cả status bar
          body: Container(
            decoration: BoxDecoration(
              gradient: _getBackgroundGradient(provider.currentWeather?.mainCondition),
            ),
            child: Stack(
              children: [
                // --- BACKGROUND BLOBS (HIỆU ỨNG TRANG TRÍ) ---
                // Hình tròn mờ 1 (Góc trên trái)
                Positioned(
                  top: -60,
                  left: -60,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
                // Hình tròn mờ 2 (Góc dưới phải)
                Positioned(
                  bottom: -80,
                  right: -20,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
                // ---------------------------------------------

                SafeArea(
                  child: Column(
                    children: [
                      // --- CUSTOM APP BAR ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, d MMMM').format(DateTime.now()), // Hiện ngày tháng
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  'Weather Forecast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                                  ),
                                ),
                              ],
                            ),
                            // Nút Settings bọc khung kính
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.settings, color: Colors.white),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- MAIN CONTENT ---
                      Expanded(
                        child: RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          onRefresh: () => provider.refreshWeather(),
                          child: _buildBody(provider),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Nút tìm kiếm nổi bật
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white.withOpacity(0.9),
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            child: ShaderMask( // Làm icon có màu gradient cho đẹp
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ).createShader(bounds);
              },
              child: const Icon(Icons.search, size: 30, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    final settings = context.watch<SettingsProvider>();
    String windValue;
    String windUnit;

    // Logic tính toán gió (Giữ nguyên)
    if (settings.isMsSpeed) {
      windValue = "${provider.currentWeather!.windSpeed}";
      windUnit = "m/s";
    } else {
      double kmh = provider.currentWeather!.windSpeed * 3.6;
      windValue = kmh.toStringAsFixed(1);
      windUnit = "km/h";
    }

    // Trạng thái Loading
    if (provider.state == WeatherState.loading) {
      return const LoadingShimmer();
    }

    // Trạng thái Lỗi
    if (provider.state == WeatherState.error) {
      return Center(
        child: ErrorWidgetCustom(
          message: provider.errorMessage,
          onRetry: () => provider.fetchWeatherByLocation(),
        ),
      );
    }

    // Chưa có dữ liệu
    if (provider.currentWeather == null) {
      return const Center(
        child: Text(
          'No weather data',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    // --- GIAO DIỆN CHÍNH ---
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Thẻ thời tiết chính (Current Weather)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CurrentWeatherCard(weather: provider.currentWeather!),
          ),

          const SizedBox(height: 30),

          // 2. Dự báo hàng giờ (Hourly) - Style Glassmorphism
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect( // ClipRRect để bo tròn khung kính
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Hiệu ứng mờ nền sau
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Màu trắng trong suốt
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: const [
                            Icon(Icons.watch_later_outlined, color: Colors.white70, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Hourly Forecast",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      HourlyForecastList(forecasts: provider.hourlyForecast),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 3. Tiêu đề "Next 5 Days"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Next 5 Days",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForecastScreen()),
                  ),
                  child: Row(
                    children: const [
                      Text("See All", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                      Icon(Icons.chevron_right, color: Colors.white70),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card dự báo ngày mai
          if (provider.forecast.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: DailyForecastCard(forecast: provider.forecast.first),
            ),

          const SizedBox(height: 20),

          // 4. Lưới chi tiết (Details Grid) - Thiết kế nghệ thuật
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5, bottom: 15),
                  child: Text(
                    "Highlights",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                    ),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                  children: [
                    _buildArtisticDetailItem(
                      icon: Icons.water_drop_outlined,
                      title: "Humidity",
                      value: "${provider.currentWeather!.humidity}%",
                      gradientColors: [Colors.blueAccent.withOpacity(0.4), Colors.lightBlue.withOpacity(0.1)],
                    ),
                    _buildArtisticDetailItem(
                      icon: Icons.air,
                      title: "Wind",
                      value: "$windValue $windUnit",
                      gradientColors: [Colors.green.withOpacity(0.4), Colors.teal.withOpacity(0.1)],
                    ),
                    _buildArtisticDetailItem(
                      icon: Icons.speed,
                      title: "Pressure",
                      value: "${provider.currentWeather!.pressure} hPa",
                      gradientColors: [Colors.orange.withOpacity(0.4), Colors.deepOrange.withOpacity(0.1)],
                    ),
                    _buildArtisticDetailItem(
                      icon: Icons.visibility_outlined,
                      title: "Visibility",
                      value: "${(provider.currentWeather!.visibility ?? 0) / 1000} km",
                      gradientColors: [Colors.purple.withOpacity(0.4), Colors.deepPurple.withOpacity(0.1)],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget con mới: Thẻ chi tiết với màu Gradient riêng biệt cho từng ô
  Widget _buildArtisticDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Icon mờ to làm nền trang trí
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.15)),
          ),
          // Nội dung chính
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}