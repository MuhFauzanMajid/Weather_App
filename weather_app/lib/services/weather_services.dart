import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  // ✅ Replace this with your actual deployed Cloud Function URL
  static const BASE_URL =
      'https://getweather-e3356f2zxq-uc.a.run.app/getWeather';

  WeatherServices();

  // Fetch weather by city name, fallback to broader searches
  Future<Weather> getWeather(String cityName) async {
    String searchCity = cityName.trim();

    // Try fetching weather for the exact city first
    var response = await _fetchWeatherData(searchCity);

    // If exact city search fails, try searching more broadly (e.g., by region or partial city names)
    if (response.statusCode != 200) {
      List<String> possibleCityNames = await _getPossibleCityNames(searchCity);

      for (String possibleCity in possibleCityNames) {
        response = await _fetchWeatherData(possibleCity);
        if (response.statusCode == 200) {
          break;
        }
      }
    }

    // Handle failure to find the city
    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data\n'
          'Status: ${response.statusCode}\n'
          'Body: ${response.body}');
    }

    return Weather.fromJson(jsonDecode(response.body));
  }

  // Helper method to fetch weather data from the Cloud Function
  Future<http.Response> _fetchWeatherData(String cityName) async {
    final uri = Uri.parse('$BASE_URL?city=$cityName');
    return await http.get(uri);
  }

  // Fallback: Get broader location names (e.g., region or admin area)
  Future<List<String>> _getPossibleCityNames(String cityName) async {
    // Using Geocoding to find multiple possible locations
    List<Location> locations = await locationFromAddress(cityName);
    List<String> possibleCities = [];

    for (var location in locations) {
      List<Placemark> placemark =
          await placemarkFromCoordinates(location.latitude, location.longitude);

      // Look for broad region names or administrative areas
      String possibleCity = placemark[0].locality ??
          placemark[0].subAdministrativeArea ??
          placemark[0].administrativeArea ??
          placemark[0].country ??
          '';
      if (!possibleCities.contains(possibleCity)) {
        possibleCities.add(possibleCity);
      }
    }

    return possibleCities;
  }

  // Fetch the current city based on the user's location
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    // Use lower accuracy to get a broader result (may include city)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low); // Use low accuracy here

    // Get a list of placemarks based on the current location
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Debugging print to see the complete placemark data
    print('Placemark Data: $placemarks');

    // Try to get the city name from the locality (if available)
    String cityName = placemarks.isNotEmpty
        ? placemarks[0].locality ?? '' // Use empty string if locality is null
        : '';

    // If the city is empty, return an error message
    if (cityName.isEmpty) {
      throw Exception("City not found. Please check your location.");
    }

    // Return the found city name
    return cityName;
  }
}
