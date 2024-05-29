import 'dart:convert';

import 'package:http/http.dart' as http;

class Weather {
  final String city;
  final double temperature;
  final String description;
  final String icon;

  const Weather(
      {required this.city,
      required this.temperature,
      required this.description,
      required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        city: json['name'],
        temperature: json['main']['temp'],
        description: json['weather'][0]['description'],
        icon: json['weather'][0]['icon']);
  }
}

class ApiService {
  static Future<Weather> fetchWeather(String city, String apiKey) async {
    Uri uriService = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(uriService);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load ${response.statusCode}');
    }
  }
}
