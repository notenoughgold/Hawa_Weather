import 'dart:math';
import 'package:date_format/date_format.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hawa/blocs/location_bloc.dart';
import 'package:hawa/models/current_weather_response.dart';
import 'package:hawa/models/forecast_response.dart';
import 'package:hawa/utility/converters.dart';
import 'package:provider/provider.dart';
import '../repository.dart';

class HomePage extends StatefulWidget {
  final String cityName;
  HomePage({
    @required this.cityName,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<CurrentWeatherResponse> currentWeatherResponse;
  Stream<ForecastResponse> forecastResponse;
  Repository _repository = Repository();
  _fetchCurrentWeather() {
    currentWeatherResponse =
        _repository.fetchCurrentWeatherUsingName(widget.cityName).asStream();
  }

  _fetchForecast() {
    forecastResponse =
        _repository.fetchWeatherForecastUsingName(widget.cityName).asStream();
  }

  String _formatDateTime(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    String str = formatDate(dateTime, [M, " ", d, ', ', HH, ':', nn]);
    return str;
  }

  String _formatHour(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    String str = formatDate(dateTime, [d, "/", m, "\n", h, " ", am]);
    return str;
  }

  Color _getSkyColorForTheme(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    int h = dateTime.hour;
    if (h >= 0 && h <= 6 || h > 18) {
      return Color(0xFF2b2f77);
    } else {
      return Colors.blue;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentWeather();
    _fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = Provider.of<LocationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit_location),
            color: Colors.white,
            tooltip: "Change location",
            onPressed: () => locationBloc.removeLocationFromSharedPreference(),
          ),
        ],
      ),
      body: StreamBuilder<Object>(
          stream: currentWeatherResponse,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            CurrentWeatherResponse currentWeatherResponse = snapshot.data;
            if (snapshot.hasError) {
              return Center(
                child: Icon(
                  Icons.error,
                  size: 64.0,
                  color: Colors.grey,
                ),
              );
            }
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                        color: _getSkyColorForTheme(currentWeatherResponse.dt),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      currentWeatherResponse.weather.first.main,
                                      style: TextStyle(
                                          fontSize: 36.0, color: Colors.white)),
                                  Text(
                                    Converters.convertKelvinToCelcius(
                                            currentWeatherResponse.main.temp) +
                                        " °C",
                                    style: TextStyle(
                                        fontSize: 48.0, color: Colors.white),
                                  ),
                                  Text(
                                    Converters.convertKelvinToCelcius(
                                            currentWeatherResponse
                                                .main.tempMax) +
                                        " °C ↑ / " +
                                        Converters.convertKelvinToCelcius(
                                            currentWeatherResponse
                                                .main.tempMin) +
                                        " °C ↓",
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Updated on ${_formatDateTime(currentWeatherResponse.dt)}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                              Container(
                                  height: 125,
                                  width: 125,
                                  child: Image.asset(
                                    "assets/weather_icons/${Converters.getWeatherIcon(currentWeatherResponse.weather.first.icon)}.png",
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: forecastResponse,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Icon(
                              Icons.error,
                              size: 64.0,
                              color: Colors.grey,
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          ForecastResponse forecastResponse = snapshot.data;
                          return Container(
                            height: 150,
                            child: ListView.builder(
                              itemCount: forecastResponse.list.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, position) {
                                return Container(
                                  height: 150,
                                  width: 100,
                                  child: Card(
                                    color: _getSkyColorForTheme(
                                        forecastResponse.list[position].dt),
                                    margin: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Converters.convertKelvinToCelcius(
                                                  forecastResponse
                                                      .list[position]
                                                      .main
                                                      .temp) +
                                              " °C",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ),
                                        Image.asset(
                                          "assets/weather_icons/${Converters.getWeatherIcon(forecastResponse.list[position].weather.first.icon)}.png",
                                          height: 60,
                                          width: 60,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          _formatHour(forecastResponse
                                              .list[position].dt),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Humidity',
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                "${currentWeatherResponse.main.humidity}%",
                                style: TextStyle(fontSize: 16.0),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Pressure',
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                "${currentWeatherResponse.main.pressure} mbar",
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Visibility',
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                "${(currentWeatherResponse.visibility ~/ 1000).toString()} Km",
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
                      height: 120.0,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Wind",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${currentWeatherResponse.wind.speed} m/s'
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Transform.rotate(
                                        angle: pi /
                                            180 *
                                            currentWeatherResponse.wind.deg,
                                        child: Icon(
                                          Icons.arrow_downward,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: FlareActor(
                              "assets/flare_anim/windmill.flr",
                              animation: "spin",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
