import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

enum LocationState { initial, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  LocationProvider(this._locationService);

  LocationState _state = LocationState.initial;
  Position? _currentPosition;
  String? _currentCity;
  String _errorMessage = '';

  // Getters
  LocationState get state => _state;
  Position? get currentPosition => _currentPosition;
  String? get currentCity => _currentCity;
  String get errorMessage => _errorMessage;

  Future<void> determinePosition() async {
    _state = LocationState.loading;
    notifyListeners();

    try {
      _currentPosition = await _locationService.getCurrentLocation();

      _currentCity = await _locationService.getCityName(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      _state = LocationState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }
}