// lib/utils/weather_icons.dart

class WeatherIcons {

  static String getUrl(String iconCode, {String size = '2x'}) {
    return 'https://openweathermap.org/img/wn/$iconCode@$size.png';
  }


}