import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Background Gradient đồng bộ với các màn hình trước
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F2833), // Xám xanh đậm
              Color(0xFF0B0C10), // Đen
            ],
          ),
        ),
        child: Stack(
          children: [
            // --- BLOBS TRANG TRÍ (Hiệu ứng ánh sáng nền) ---
            Positioned(
              top: -80,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent.withOpacity(0.1),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // --- LIST CÀI ĐẶT ---
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 110, 20, 30), // Top 110 tránh AppBar
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSectionHeader("Units"),
                const SizedBox(height: 10),
                // Gom nhóm Units vào 1 block kính lớn
                Container(
                  decoration: _glassDecoration(),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        icon: Icons.thermostat,
                        iconColor: Colors.orangeAccent,
                        title: "Temperature",
                        subtitle: settings.isCelsius ? "Celsius (°C)" : "Fahrenheit (°F)",
                        value: settings.isCelsius,
                        onChanged: (val) => context.read<SettingsProvider>().toggleTemperature(val),
                        isFirst: true,
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.air,
                        iconColor: Colors.cyanAccent,
                        title: "Wind Speed",
                        subtitle: settings.isMsSpeed ? "Meters/sec (m/s)" : "Km/hour (km/h)",
                        value: settings.isMsSpeed,
                        onChanged: (val) => context.read<SettingsProvider>().toggleWindSpeed(val),
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                _buildSectionHeader("Interface"),
                const SizedBox(height: 10),
                Container(
                  decoration: _glassDecoration(),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        icon: Icons.schedule,
                        iconColor: Colors.blueAccent,
                        title: "Time Format",
                        subtitle: settings.is24HourFormat ? "24 Hour (13:00)" : "12 Hour (1:00 PM)",
                        value: settings.is24HourFormat,
                        onChanged: (val) => context.read<SettingsProvider>().toggleTimeFormat(val),
                        isFirst: true,
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.dark_mode,
                        iconColor: Colors.purpleAccent,
                        title: "Dark Theme",
                        subtitle: settings.isDarkTheme ? "Always Dark" : "Adaptive",
                        value: settings.isDarkTheme,
                        onChanged: (val) => context.read<SettingsProvider>().toggleTheme(val),
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                // Nút Reset
                _buildResetButton(context),
                
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Weather App v1.0",
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Decoration cho khung kính mờ chung
  BoxDecoration _glassDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.2), // Màu nền đen mờ (quan trọng để tạo độ "xẩm")
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    );
  }

  // Đường kẻ phân cách giữa các item
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 60, // Thụt vào để không cắt qua icon
      endIndent: 20,
      color: Colors.white.withOpacity(0.1),
    );
  }

  // Tiêu đề nhóm (UNITS, INTERFACE...)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.blueAccent.withOpacity(0.8),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Widget từng dòng cài đặt (Switch)
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return ClipRRect(
      // Bo góc tùy theo vị trí (đầu/cuối danh sách)
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(20) : Radius.zero,
        bottom: isLast ? const Radius.circular(20) : Radius.zero,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Material( // Dùng Material để có hiệu ứng gợn sóng khi bấm
          color: Colors.transparent,
          child: SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            activeColor: iconColor, // Màu nút gạt theo màu icon
            activeTrackColor: iconColor.withOpacity(0.4),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.white10,
            secondary: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2), // Nền icon mờ cùng tông
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
              ),
            ),
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Widget nút Reset riêng biệt
  Widget _buildResetButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showResetDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.refresh, color: Colors.redAccent, size: 20),
            SizedBox(width: 10),
            Text(
              "Reset Default Settings",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hộp thoại Reset (Dark Theme)
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2833), // Nền tối
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Reset Settings", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to restore all settings to default?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              context.read<SettingsProvider>().resetSettings();
              Navigator.pop(ctx);
            },
            child: const Text("Reset", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}