import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherServices(dotenv.env['API_KEY']!);
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
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/images/clear_sky.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/images/cloudy.json';
      case 'mist':
        return 'assets/images/mist.json';
      case 'smoke':
        return 'assets/images/mist.json';
      case 'haze':
        return 'assets/images/mist.json';
      case 'dust':
        return 'assets/images/mist.json';
      case 'fog':
        return 'assets/images/mist.json';
      case 'rain':
        return 'assets/images/rain.json';
      case 'drizzle':
        return 'assets/images/rain.json';
      case 'shower rain':
        return 'assets/images/rain.json';
      case 'thunderstorm':
        return 'assets/images/thunderstorm.json';
      case 'clear':
        return 'assets/images/clear_sky.json';
      default:
        return 'assets/images/clear_sky.json';
    }
  }

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

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round()}°C')
          ],
        ),
      ),
    );
  }
}
