import 'package:flutter/material.dart';
import 'package:hawa/models/forecast_response.dart';
import 'package:hawa/utility/api_key.dart';
import 'package:hawa/models/current_weather_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_KEY = api_key;

class Repository {
  Repository();

  Future<CurrentWeatherResponse> fetchCurrentWeatherUsingName(
      String name) async {
    // String response = await rootBundle.loadString('assets/fake_response.json');
    // debugPrint(response);
    // return CurrentWeatherResponse.fromJson(json.decode(response));
    String fetchUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$name&APPID=$API_KEY";
    http.Response response = await http.get(fetchUrl);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      // If server returns an OK response, parse the JSON
      CurrentWeatherResponse currentWeatherResponse =
          CurrentWeatherResponse.fromJson(json.decode(response.body));

      return currentWeatherResponse;
    } else {
      // If that response was not OK, throw an error
      debugPrint("loading failed");
      throw Exception('Failed to load');
    }
  }

  Future<ForecastResponse> fetchWeatherForecastUsingName(String name) async {
    String fetchUrl =
        "http://api.openweathermap.org/data/2.5/forecast?q=$name&APPID=$API_KEY";
    http.Response response = await http.get(fetchUrl);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      // If server returns an OK response, parse the JSON
      ForecastResponse forecastResponse =
          ForecastResponse.fromJson(json.decode(response.body));

      return forecastResponse;
    } else {
      // If that response was not OK, throw an error
      debugPrint("loading failed");
      throw Exception('Failed to load');
    }

    // String response =
    //     await rootBundle.loadString('assets/fake_response_forecast.json');
    // debugPrint(response);

    // return ForecastResponse.fromJson(json.decode(response));
  }
}
