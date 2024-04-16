class WeatherException implements Exception {
  String message;

  WeatherException([this.message = 'something went wrong']) {
    message = 'Weather exception: $message';
  }

}