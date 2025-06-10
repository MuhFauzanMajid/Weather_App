import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:intl/intl.dart';

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
    final Size screenSize = MediaQuery.of(context).size;
    final DateTime tanggal = DateTime.now();

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 20,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      Colors.green.withOpacity(0.7), // Warna hijau transparan
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // ✅ Show error if any
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize:
                                24, // Membuat teks lebih besar. Sesuaikan nilainya sesuai keinginan.
                            fontWeight:
                                FontWeight.bold, // Membuat teks menjadi tebal
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Pusatkan konten Row secara horizontal
                      children: [
                        // Animasi Lottie
                        Lottie.asset(
                          getWeatherAnimation(_weather?.mainCondition),
                          height: 100, // Ukuran tinggi animasi
                          width: 100, // Ukuran lebar animasi
                        ),
                        const SizedBox(
                            width:
                                10), // Memberi sedikit jarak antara animasi dan suhu

                        // Suhu
                        Text(
                          _weather != null
                              ? '${_weather!.temperature.round()}°'
                              : "",
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _weather?.mainCondition ?? "Loading...",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold),
                    ),

                    // ✅ Show the city name that was sent to the API
                    Text(
                      _cityName.isNotEmpty ? "$_cityName" : "Loading city...",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      // Langsung memformat objek DateTime
                      DateFormat('EEEE dd/MMMM/yyyy').format(tanggal),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
