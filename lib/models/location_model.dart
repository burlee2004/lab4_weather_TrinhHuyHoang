// lib/models/location_model.dart

class LocationModel {
  final double latitude;
  final double longitude;
  final String? cityName;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.cityName,
  });

   Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      cityName: json['cityName'],
    );
  }
}