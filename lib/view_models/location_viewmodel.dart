import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repository/repository.dart';

enum ViewState { geliyor, geldi, hata }

class LocationViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewState _state = ViewState.geliyor;
  ViewState get state => _state;
  bool isListening = false;
  bool location = true;
  Weather weather = Weather(
      coord: Coord(lon: 0, lat: 0),
      weather: [
        WeatherElement(
            id: 0, main: "main", description: "description", icon: "icon")
      ],
      base: "base",
      main: Main(
          temp: 0,
          feelsLike: 0,
          tempMin: 0,
          tempMax: 0,
          pressure: 0,
          humidity: 0),
      visibility: 0,
      wind: Wind(speed: 0, deg: 0),
      clouds: Clouds(all: 0),
      dt: 0,
      sys: Sys(type: 0, id: 0, country: "country", sunrise: 0, sunset: 0),
      timezone: 0,
      id: 0,
      name: "name",
      cod: 0);
  int sayi = 0;
  TextToSpeech tts = TextToSpeech();
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  void getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    state = ViewState.geliyor;
    location = true;
    try {
      LocationHelper locationHelper = await _repository.getCurrentLocation();
      weather = await _repository.getWeatherKonum(
          locationHelper.latitude, locationHelper.longitude);
      state = ViewState.geldi;
      sayi = 1;
      String text =
          "${weather.name} Şehrinde Hava Bugün ${weather.main.temp.toInt()} Derece ve ${weather.weather[0].description}";
      tts.speak(text);
    } catch (e) {
      state = ViewState.hata;
    }
  }

  void getWeather(String sehir) async {
    await Future.delayed(const Duration(milliseconds: 100));
    state = ViewState.geliyor;
    location = false;
    try {
      weather = await _repository.getWeather(sehir);
      state = ViewState.geldi;
      sayi = 1;
      String text =
          "${weather.name} Şehrinde Hava Şuan ${weather.main.temp.toInt()} Derece ve ${weather.weather[0].description}";
      tts.speak(text);
    } catch (e) {
      String text =
          "$sehir şehri için veri getirilemedi. Lütfen tekrar deneyiniz!";
      tts.speak(text);
      state = ViewState.hata;
    }
  }
}
