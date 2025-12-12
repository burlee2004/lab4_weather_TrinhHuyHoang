import 'dart:ui'; // Cần cho hiệu ứng mờ (ImageFiltered, BackdropFilter)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadSearchHistory();
    });
  }

  void _submitSearch(String city) {
    if (city.isNotEmpty) {
      context.read<WeatherProvider>().fetchWeatherByCity(city);
      Navigator.pop(context);
    }
  }

  // Dialog đẹp hơn, đồng bộ theme
  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Làm mờ nền sau dialog
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A1F38).withOpacity(0.9), // Xanh đen đậm
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
              SizedBox(width: 10),
              Text("Clear History", style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete all search history?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.read<WeatherProvider>().clearSearchHistory();
                Navigator.pop(ctx);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<WeatherProvider>().searchHistory;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Find Your City",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        // --- NỀN GRADIENT SANG TRỌNG (Deep Blue -> Purple) ---
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027), // Xanh đen thẳm (Midnight)
              Color(0xFF203A43), // Xanh cổ vịt đậm
              Color(0xFF2C5364), // Xanh đá (Slate)
              // Hoặc bạn có thể thử combo tím: [Color(0xFF2E3192), Color(0xFF1BFFFF)]
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // --- SEARCH BAR (GLASSMORPHISM XỊN) ---
                _GlassBox(
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    cursorColor: Colors.cyanAccent,
                    decoration: InputDecoration(
                      hintText: 'Search city (e.g., Hanoi, Tokyo)...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () => _controller.clear(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: _submitSearch,
                  ),
                ),
                
                const SizedBox(height: 30),

                // --- RECENT SEARCHES ---
                if (history.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "History",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      TextButton.icon(
                        onPressed: () => _showClearHistoryDialog(context),
                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.pinkAccent),
                        label: const Text("Clear", style: TextStyle(color: Colors.pinkAccent)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: history.map((city) {
                      return InkWell(
                        onTap: () => _submitSearch(city),
                        borderRadius: BorderRadius.circular(20),
                        child: _GlassBox(
                          borderRadius: 20,
                          color: Colors.white.withOpacity(0.08),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.history, size: 16, color: Colors.white60),
                              const SizedBox(width: 8),
                              Text(city, style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],

                // --- POPULAR CITIES (GRID VIEW) ---
                const Text(
                  "Popular Cities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 15),
                
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // 2 Cột
                    childAspectRatio: 2.5, // Tỷ lệ chiều rộng/cao của thẻ
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildCityCard("Hanoi", Icons.location_city, Colors.blue),
                      _buildCityCard("Ho Chi Minh", Icons.business, Colors.orange),
                      _buildCityCard("Da Nang", Icons.beach_access, Colors.cyan),
                      _buildCityCard("London", Icons.apartment, Colors.indigo),
                      _buildCityCard("New York", Icons.local_activity, Colors.purple),
                      _buildCityCard("Tokyo", Icons.brightness_3, Colors.pink),
                      _buildCityCard("Seoul", Icons.star_border, Colors.teal),
                      _buildCityCard("Paris", Icons.local_cafe, Colors.brown),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget thẻ thành phố dạng Grid (Đẹp hơn List)
  Widget _buildCityCard(String city, IconData icon, Color iconColor) {
    return InkWell(
      onTap: () => _submitSearch(city),
      borderRadius: BorderRadius.circular(20),
      child: _GlassBox(
        borderRadius: 20,
        color: Colors.white.withOpacity(0.05), // Rất trong
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2), // Màu nền icon nhạt theo màu chính
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                city,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET HELPER: TẠO HIỆU ỨNG KÍNH (GLASSMORPHISM) ---
class _GlassBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const _GlassBox({
    required this.child,
    this.borderRadius = 15,
    this.padding = EdgeInsets.zero,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Độ mờ kính (Blur)
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.1), // Màu trắng đục nhẹ
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.1), // Viền sáng nhẹ
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}