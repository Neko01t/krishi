import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  final Map<String, dynamic> weatherData;

  const WeatherScreen({super.key, required this.weatherData});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  List<Map<String, dynamic>> forecast = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get the current position using the new settings approach
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimum distance (in meters) before an update
      ),
    );
  }

  Future<void> fetchForecast() async {
    try {
      double latitude;
      double longitude;

      if (Platform.isLinux) {
        // Fixed coordinates for Sambhajinagar
        latitude = 19.8762;
        longitude = 75.3433;
      } else {
        // Try to get user location but add a timeout (10s max)
        Position position = await Future.any([
          _getUserLocation(),
          Future.delayed(Duration(seconds: 10), () {
            throw TimeoutException('Location fetching timed out.');
          }),
        ]);
        latitude = position.latitude;
        longitude = position.longitude;
      }

      final url = Uri.parse(
        'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$latitude&lon=$longitude',
      );

      final response = await Future.any([
        http.get(
          url,
          headers: {'User-Agent': 'YourAppName/1.0 (your.email@example.com)'},
        ),
        Future.delayed(Duration(seconds: 10), () {
          throw TimeoutException('Weather API response timed out.');
        }),
      ]);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> timeseries =
            (data['properties']['timeseries'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();

        Map<String, Map<String, dynamic>> dailyForecast = {};
        for (var entry in timeseries) {
          DateTime date = DateTime.parse(entry['time']);
          String day = DateFormat('yyyy-MM-dd').format(date);
          if (!dailyForecast.containsKey(day)) {
            dailyForecast[day] = {
              'date': date,
              'temp': entry['data']['instant']['details']['air_temperature'],
            };
          }
        }

        setState(() {
          forecast = dailyForecast.values.take(7).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching weather: ${e.toString()}';
        isLoading = false;

        // Default to Aurangabad if fetch fails
        forecast = [
          for (int i = 0; i < 7; i++)
            {
              'date': DateTime.now().add(Duration(days: i)),
              'temp': 28 + i,
            }
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.weatherData['name'] == 'Aurangabad'
                ? 'Weather in Sambhajinagar'
                : "Weather in ${widget.weatherData['name']}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade200,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Temperature Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text("${widget.weatherData['main']['temp']}°C",
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    widget.weatherData['weather'][0]
                                        ['description'],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Humidity & Wind Speed Row
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                // elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.water_drop,
                                      color: Colors.blue),
                                  title: Text("Humidity"),
                                  subtitle: Text(
                                      "${widget.weatherData['main']['humidity']}%"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.wind_power,
                                      color: Colors.green),
                                  title: Text("Wind Speed"),
                                  subtitle: Text(
                                      "${widget.weatherData['wind']['speed']} m/s"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Weather Forecast Chart
                        if (forecast.isNotEmpty)
                          SizedBox(
                            height: 260, // Adjusted height for better spacing
                            child: BarChart(
                              BarChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.grey.shade300,
                                    strokeWidth: 1,
                                    dashArray: [4, 4],
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles:
                                          true, // Show left (temperature) values
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            '${value.toInt()}°C',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles:
                                              false)), // Hide right values
                                  topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles:
                                              false)), // Hide top values
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize:
                                          30, // Extra space to move it below bars
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index >= 0 &&
                                            index < forecast.length) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top:
                                                    8.0), // Moves text slightly lower
                                            child: Text(
                                              DateFormat('E').format(
                                                  forecast[index]['date']),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false, // Hide borders to make it clean
                                ),
                                barGroups:
                                    forecast.asMap().entries.map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value['temp'].toDouble(),
                                        width: 16,
                                        borderRadius: BorderRadius.circular(
                                            6), // Rounded bars
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue.shade400,
                                            Colors.blue.shade200
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        SizedBox(height: 16),

                        // 7-Day Forecast
                        Text("7-Day Forecast",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),

                        SizedBox(
                          height: 140,
                          child: forecast.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          12), // Adds margin on both sides
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(7, (index) {
                                        var day = forecast[index];
                                        int temp = day['temp'].toInt();

                                        String emoji = '⚫';
                                        if (temp >= 40) {
                                          emoji = '🔥';
                                        } else if (temp >= 30) {
                                          emoji = '🟡';
                                        } else if (temp >= 20) {
                                          emoji = '🌡️';
                                        } else if (temp <= 19) {
                                          emoji = '❄️';
                                        }

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat('MMM d, E')
                                                    .format(day['date']),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue.shade800,
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                emoji,
                                                style: TextStyle(
                                                    fontSize:
                                                        24), // Bigger emoji
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "${day['temp']}°C",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                )
                              : Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
