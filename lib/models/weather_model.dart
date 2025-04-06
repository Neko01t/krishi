class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final bool isDayTime;
  final Map<String, dynamic> fullData; // Store full API response

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.isDayTime,
    required this.fullData,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    String weatherIcon = json['weather'][0]['icon'];
    return WeatherModel(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      icon: "https://openweathermap.org/img/wn/$weatherIcon@2x.png",
      isDayTime: weatherIcon.contains("d"),
      fullData: json, // Store everything from API response
    );
  }
}
