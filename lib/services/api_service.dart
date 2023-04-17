import 'package:dio/dio.dart';
import 'package:weather_app/models/weather.dart';

class ApiService {
  String key = "4174ae1e94d71d38af70e2400413846d";
  List skyTypes = [
    'clear sky',
    'few clouds',
    'overcast clouds',
    'scattered clouds',
    'broken clouds',
    'shower rain',
    'rain',
    'thunderstorm',
    'snow',
    'mist'
  ];
  List skyTypesTR = [
    'Açık',
    'Az Bulutlu',
    'Çok Bulutlu(Kapalı)',
    'Alçak Bulutlu',
    'Parçalı Bulutlu',
    'Sağanak Yağmurlu',
    'Yağmurlu',
    'Gök Gürültülü Fırtına',
    'Karlı',
    'Puslu'
  ];
  getWeatherKonum(double latitude, double longitude) async {
    String yol =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$key&units=metric";
    try {
      var response = await Dio().get(yol);
      Weather havaDurumu = Weather.fromMap(response.data);
      for (int i = 0; i < 10; i++) {
        if (havaDurumu.weather[0].description == skyTypes[i]) {
          havaDurumu.weather[0].description = skyTypesTR[i];
          return havaDurumu;
        }
      }
      return havaDurumu;
      // ignore: empty_catches
    } catch (e) {}
  }

  getWeather(String sehir) async {
    String yol =
        "https://api.openweathermap.org/data/2.5/weather?q=$sehir&appid=$key&units=metric";
    try {
      var response = await Dio().get(yol);
      Weather havaDurumu = Weather.fromMap(response.data);
      for (int i = 0; i < 10; i++) {
        if (havaDurumu.weather[0].description == skyTypes[i]) {
          havaDurumu.weather[0].description = skyTypesTR[i];
          return havaDurumu;
        }
      }

      return havaDurumu;
      // ignore: empty_catches
    } catch (e) {}
  }
}
