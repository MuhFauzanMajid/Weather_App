import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherServices("5c34f6500681e43b2dd210c6013577f9");
  Weather? _weather;

  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final Weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = Weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation

  // init state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "Loading city"),

            // temperature
            Text('${_weather?.temperature.round()}°C')
          ],
        ),
      ),
    );
  }
}
