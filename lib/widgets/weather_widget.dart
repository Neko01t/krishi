import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krishi/screens/weather_screen.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final String apiKey = "446d53719ee112afbf4515e2368bf179";
  String city = "Aurangabad";
  Map<String, dynamic> weatherData = {};
  Timer? _timer;
  bool isLoading = true;
  String loadingTemp = "--";
  String loadingWind = "--";
  String loadingHumidity = "--";
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    fetchWeather();
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      fetchWeather();
    });
    _startLoadingAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startLoadingAnimation() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!isLoading) {
        timer.cancel();
      } else {
        setState(() {
          loadingTemp = "${_random.nextInt(99)}°C";
          loadingWind = "${_random.nextInt(10)}.${_random.nextInt(9)} m/s";
          loadingHumidity = "${_random.nextInt(100)}%";
        });
      }
    });
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String temperature = "${weatherData['main']?['temp'] ?? loadingTemp}";
    String weatherCondition =
        weatherData['weather']?[0]['description']?.toString().toUpperCase() ??
            "LOADING";
    String iconUrl = weatherData.isNotEmpty
        ? "https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png"
        : "https://openweathermap.org/img/wn/01d@2x.png";
    bool isDayTime = weatherData.isNotEmpty &&
        weatherData['weather'][0]['icon'].contains("d");
    String windSpeed = "${weatherData['wind']?['speed'] ?? loadingWind}";
    String humidity = "${weatherData['main']?['humidity'] ?? loadingHumidity}";

    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherScreen(weatherData: weatherData),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Image.network(iconUrl, width: 65, height: 65),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      temperature,
                      key: ValueKey(temperature),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    weatherCondition,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  city == 'Aurangabad' ? 'Sambhajinagar' : city,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 184, 104),
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      isDayTime
                          ? "assets/icons/day-sun-clean.svg"
                          : "assets/icons/night-moon-clean.svg",
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        "$windSpeed  |  $humidity",
                        key: ValueKey("$windSpeed  |  $humidity"),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
