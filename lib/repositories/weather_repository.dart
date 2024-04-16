import 'package:open_weather_provider/exceptions/weather_exception.dart';
import 'package:open_weather_provider/models/custom_error.dart';
import 'package:open_weather_provider/services/weather_api_service.dart';

import '../models/weather.dart';

class WeatherRepository {
  final WeatherApiService weatherApiService;

  WeatherRepository({required this.weatherApiService});

  Future<Weather> fetchWeather(String city) async {
    try {
      final directGeocoding = await weatherApiService.getDirectGeocoding(city);
      print('directGeocoding: $directGeocoding');

      final tempWeather = await weatherApiService.getWeather(directGeocoding);
      print('tempWeather: $tempWeather');

      final weather = tempWeather.copyWith(name: directGeocoding.name, country: directGeocoding.country);
      print('weather: $weather');

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch(e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}