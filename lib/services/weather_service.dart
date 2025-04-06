import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String apiKey = "446d53719ee112afbf4515e2368bf179";
  static const String baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherModel?> fetchWeather(String city) async {
    final url = Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }
}
