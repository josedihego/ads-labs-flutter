import 'package:flutter/material.dart';
import 'package:weather_api/data_layer.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
          useMaterial3: true),
      home: const MyHomeWeather(title: 'Wather app'),
    );
  }
}

class MyHomeWeather extends StatefulWidget {
  const MyHomeWeather({super.key, required this.title});
  final String title;

  @override
  State<MyHomeWeather> createState() => _MyHomeWeatherState();
}

class _MyHomeWeatherState extends State<MyHomeWeather> {
  final _cityController = TextEditingController();
  Weather? _weather; // it can be null

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _getWeather() async {
    const apiKey = 'your_api_key';
    final weather = await ApiService.fetchWeather(_cityController.text, apiKey);
    setState(() {
      _weather = weather;
    });
  }

  Widget buildWeather(BuildContext context, Weather weather) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.city,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '${weather.temperature}°C',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            weather.description,
            style: TextStyle(fontSize: 16),
          ),
          Image.network(
            'http://openweathermap.org/img/wn/${weather.icon}@2x.png',
            width: 100,
            height: 100,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                  hintText: 'Enter city name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _getWeather,
                  )),
            ),
          ),
          if (_weather != null) buildWeather(context, _weather!)
        ],
      ),
    );
  }
}
