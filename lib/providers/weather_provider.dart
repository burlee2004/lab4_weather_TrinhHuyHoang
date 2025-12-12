// lib/providers/weather_provider.dart

import 'package:flutter/material.dart';
import '../models/hourly_weather_model.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;
List<HourlyWeatherModel> _hourlyForecast = [];
  List<HourlyWeatherModel> get hourlyForecast => _hourlyForecast;
  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
List<String> _searchHistory = [];
  List<String> get searchHistory => _searchHistory;
  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
    this._connectivityService,
  );

  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  // Fetch weather by city
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final hasInternet = await _connectivityService.isConnected;
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _hourlyForecast = await _weatherService.getHourlyForecast(cityName);
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      await _storageService.addToSearchHistory(cityName);
      _searchHistory = await _storageService.getSearchHistory();
      if (!hasInternet) {
        await loadCachedWeather();
        if (_currentWeather != null) {
          _errorMessage = 'No internet connection. Showing cached data.';
          _state = WeatherState.loaded;
        } else {
          _state = WeatherState.error;
          _errorMessage = 'No internet connection and no cached data.';
        }
        notifyListeners();
        return;
      }
      // -------------------------------

      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      
      _forecast = await _weatherService.getForecast(cityName);
      _hourlyForecast = await _weatherService.getHourlyForecast(cityName);
      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Fetch weather by current location
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      _forecast = await _weatherService.getForecast(cityName);
      _hourlyForecast = await _weatherService.getHourlyForecast(cityName);
      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();

      // Try to load cached data
      await loadCachedWeather();
    }

    notifyListeners();
  }

  // Load cached weather
  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
//load hítory
  Future<void> loadSearchHistory() async {
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }
  Future<void> clearSearchHistory() async {
    // 1. Xóa trong bộ nhớ máy
    await _storageService.clearSearchHistory();
    
    // 2. Xóa list trong RAM để UI cập nhật ngay
    _searchHistory.clear();
    
    // 3. Thông báo cho màn hình Search vẽ lại
    notifyListeners();
  }
}