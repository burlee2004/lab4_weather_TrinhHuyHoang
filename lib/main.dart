// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/api_config.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';
import 'providers/weather_provider.dart';
import 'providers/location_provider.dart';
import 'screens/home_screen.dart';
import 'providers/settings_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
print("---------- DEBUG API KEY ----------");
  print("Key from .env: ${ApiConfig.apiKey}"); 
  print("Is Key Empty?: ${ApiConfig.apiKey.isEmpty}");
  print("-----------------------------------");
  runApp(
    MultiProvider(
      providers: [

        Provider(create: (_) => WeatherService(apiKey: ApiConfig.apiKey)),
        Provider(create: (_) => LocationService()),
        Provider(create: (_) => StorageService()),
        Provider(create: (_) => ConnectivityService()),
        ChangeNotifierProxyProvider4<WeatherService, LocationService, StorageService, ConnectivityService, WeatherProvider>(
          create: (context) => WeatherProvider(
            context.read<WeatherService>(),
            context.read<LocationService>(),
            context.read<StorageService>(),
            context.read<ConnectivityService>(),
          ),
          update: (context, weather, location, storage, connectivity, previous) =>
              WeatherProvider(weather, location, storage, connectivity),
        ),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<LocationService, LocationProvider>(
          create: (context) => LocationProvider(context.read<LocationService>()),
          update: (context, locationService, previous) => 
              LocationProvider(locationService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'Flutter Weather App',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1A202C), // Màu nền tối theo yêu cầu
      ),
      home: HomeScreen(),
    );
  }
}