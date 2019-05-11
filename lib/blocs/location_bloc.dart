import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationBloc {
  BehaviorSubject<String> _locationSubject =
      BehaviorSubject<String>.seeded(null);
  SharedPreferences preferences;

  LocationBloc() {
    getSharedPreferencesInstance();
  }
  Future<void> getSharedPreferencesInstance() async {
    preferences = await SharedPreferences.getInstance();
    String locationName = preferences.getString('Location');
    _locationSubject.sink.add(locationName);
  }

  Observable<String> get locationObservable => _locationSubject.stream;

  void removeLocationFromSharedPreference() async {
    debugPrint("removeLocationFromSharedPreference called");
    String oldLocation = (preferences.getString('Location'));
    debugPrint('old Location was $oldLocation');
    await preferences
        .setString('Location', null)
        .then((_) => debugPrint("old location removed"))
        .then((_) => _locationSubject.sink.add(null));
  }

  void writeLocationToSharedPreference(String location) async {
    debugPrint("location write func called");
    String oldLocation = (preferences.getString('Location'));
    debugPrint('old Location was $oldLocation');
    await preferences
        .setString('Location', location)
        .then((_) => debugPrint("new location $location written"))
        .then((_) => _locationSubject.sink.add(location));
  }

  void dispose() {
    _locationSubject.close();
  }
}
