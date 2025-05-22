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
  final _weatherService = WeatherServices();
  Weather? _weather;

  String _error = '';
  String _cityName = ''; // Variable to store the city name being sent

  _fetchWeather() async {
    try {
      // Fetch the city name
      String cityName = await _weatherService.getCurrentCity();

      // Save the city name to show what is being sent to the API
      setState(() {
        _cityName = cityName;
      });

      // Fetch the weather data for the city
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
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
            // ✅ Show error if any
            if (_error.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: $_error',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // ✅ Show the city name that was sent to the API
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _cityName.isNotEmpty ? "City : $_cityName" : "Loading city...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // city name
            Text(_weather?.cityName ?? "Loading city..."),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text(
              _weather != null ? '${_weather!.temperature.round()}°C' : "",
            ),
          ],
        ),
      ),
    );
  }
}
